package com.bestseller.demo.service;

import com.bestseller.demo.plugin.ItemPlugin;
import com.bestseller.demo.plugin.StockPlugin;
import com.bestseller.demo.plugin.TrackingPlugin;
import com.microsoft.semantickernel.Kernel;
import com.microsoft.semantickernel.orchestration.InvocationContext;
import com.microsoft.semantickernel.orchestration.PromptExecutionSettings;
import com.microsoft.semantickernel.plugin.KernelPlugin;
import com.microsoft.semantickernel.plugin.KernelPluginFactory;
import com.microsoft.semantickernel.services.chatcompletion.ChatCompletionService;
import com.microsoft.semantickernel.services.chatcompletion.ChatHistory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * Service demonstrating how to use Semantic Kernel with plugins.
 * This service shows how kernel functions can be invoked to answer user queries.
 */
@Service
public class SemanticKernelService {

    private static final Logger logger = LoggerFactory.getLogger(SemanticKernelService.class);

    private final Kernel kernel;
    private final ItemPlugin itemPlugin;
    private final StockPlugin stockPlugin;
    private final TrackingPlugin trackingPlugin;

    public SemanticKernelService(
        Kernel kernel,
        ItemPlugin itemPlugin,
        StockPlugin stockPlugin,
        TrackingPlugin trackingPlugin
    ) {
        this.kernel = kernel;
        this.itemPlugin = itemPlugin;
        this.stockPlugin = stockPlugin;
        this.trackingPlugin = trackingPlugin;
        
        logger.info("SemanticKernelService initialized with kernel and plugins");
    }

    /**
     * Demonstrates invoking a specific kernel function directly.
     * For simplicity in this demo, we directly call the plugin methods.
     *
     * @param pluginName the name of the plugin
     * @param functionName the name of the function
     * @param parameter the parameter to pass to the function
     * @return the result of the function invocation
     */
    public String invokeKernelFunction(String pluginName, String functionName, String parameter) {
        try {
            logger.info("Invoking kernel function: {}.{} with parameter: {}", 
                pluginName, functionName, parameter);

            String result;
            
            // For demo simplicity, route to the appropriate plugin method
            // In a real scenario with AI, the LLM would automatically choose the right function
            if (pluginName.equalsIgnoreCase("ItemPlugin")) {
                if (functionName.equalsIgnoreCase("getItemInfo")) {
                    result = itemPlugin.getItemInfo(parameter);
                } else if (functionName.equalsIgnoreCase("searchItemsByCategory")) {
                    result = itemPlugin.searchItemsByCategory(parameter);
                } else {
                    result = "Unknown function: " + functionName;
                }
            } else if (pluginName.equalsIgnoreCase("StockPlugin")) {
                if (functionName.equalsIgnoreCase("getStockInfo")) {
                    result = stockPlugin.getStockInfo(parameter);
                } else if (functionName.equalsIgnoreCase("checkAvailability")) {
                    result = stockPlugin.checkAvailability(parameter);
                } else {
                    result = "Unknown function: " + functionName;
                }
            } else if (pluginName.equalsIgnoreCase("TrackingPlugin")) {
                if (functionName.equalsIgnoreCase("getTrackingInfo")) {
                    result = trackingPlugin.getTrackingInfo(parameter);
                } else if (functionName.equalsIgnoreCase("getDeliveryStatus")) {
                    result = trackingPlugin.getDeliveryStatus(parameter);
                } else {
                    result = "Unknown function: " + functionName;
                }
            } else {
                result = "Unknown plugin: " + pluginName;
            }

            logger.info("Function result: {}", result);
            return result;

        } catch (Exception e) {
            logger.error("Error invoking kernel function", e);
            return "Error: " + e.getMessage();
        }
    }

    /**
     * Demonstrates using the kernel with chat completion and automatic function calling.
     * Note: This requires proper Azure OpenAI configuration with function calling support.
     *
     * @param userMessage the user's message/query
     * @return Mono containing the AI's response
     */
    public reactor.core.publisher.Mono<String> chat(String userMessage) {
        logger.info("Processing chat message: {}", userMessage);

        try {
            ChatCompletionService chatService = kernel.getService(ChatCompletionService.class);
            ChatHistory history = new ChatHistory();
            
            // Add system message to guide the AI
            history.addSystemMessage(
                "You are a helpful assistant for BESTSELLER that can help users with product information, " +
                "stock availability, and tracking shipments. Use the available functions to retrieve " +
                "accurate information. When users ask about items, use IDs like 'item-001', 'item-002', " +
                "or 'item-003'. For tracking, use numbers like 'TRK-2025-001' or 'TRK-2025-002'."
            );
            
            // Add user message
            history.addUserMessage(userMessage);

            // Create invocation context with auto-invoke enabled
            var executionSettings = PromptExecutionSettings.builder()
                .withTemperature(0.7)
                .build();

            var invocationContext = InvocationContext.builder()
                .withPromptExecutionSettings(executionSettings)
                .build();

            // Get chat completion reactively
            return chatService.getChatMessageContentsAsync(
                    history,
                    kernel,
                    invocationContext
                )
                .map(response -> {
                    String aiResponse = response.get(0).getContent();
                    logger.info("AI response: {}", aiResponse);
                    return aiResponse;
                })
                .onErrorResume(e -> {
                    logger.error("Error processing chat message", e);
                    return reactor.core.publisher.Mono.just(
                        "Error processing your request: " + e.getMessage() + 
                        ". Note: This feature requires proper Azure OpenAI configuration."
                    );
                });
        } catch (Exception e) {
            logger.error("Error initializing chat service", e);
            return reactor.core.publisher.Mono.just(
                "Error initializing chat service: " + e.getMessage() + 
                ". Note: This feature requires proper Azure OpenAI configuration."
            );
        }
    }
}
