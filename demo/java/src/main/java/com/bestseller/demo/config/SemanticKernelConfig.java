package com.bestseller.demo.config;

import com.azure.ai.openai.OpenAIAsyncClient;
import com.azure.ai.openai.OpenAIClientBuilder;
import com.azure.core.credential.AzureKeyCredential;
import com.bestseller.demo.plugin.ItemPlugin;
import com.bestseller.demo.plugin.StockPlugin;
import com.bestseller.demo.plugin.TrackingPlugin;
import com.microsoft.semantickernel.Kernel;
import com.microsoft.semantickernel.aiservices.openai.chatcompletion.OpenAIChatCompletion;
import com.microsoft.semantickernel.plugin.KernelPlugin;
import com.microsoft.semantickernel.plugin.KernelPluginFactory;
import com.microsoft.semantickernel.services.chatcompletion.ChatCompletionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for Microsoft Semantic Kernel.
 * Sets up Azure OpenAI connection and creates the Kernel instance.
 */
@Configuration
public class SemanticKernelConfig {

    private static final Logger logger = LoggerFactory.getLogger(SemanticKernelConfig.class);

    @Value("${azure.openai.endpoint:https://your-resource-name.openai.azure.com}")
    private String azureOpenAiEndpoint;

    @Value("${azure.openai.api-key:your-api-key-here}")
    private String azureOpenAiApiKey;

    @Value("${azure.openai.deployment-name:gpt-4}")
    private String deploymentName;

    /**
     * Creates a Kernel instance configured with Azure OpenAI and plugins.
     * The Kernel is the central orchestration point for Semantic Kernel operations.
     *
     * @return configured Kernel instance
     */
    @Bean
    public Kernel kernel(ItemPlugin itemPlugin, StockPlugin stockPlugin, TrackingPlugin trackingPlugin) {
        logger.info("Initializing Semantic Kernel with Azure OpenAI");
        logger.info("Endpoint: {}", azureOpenAiEndpoint);
        logger.info("Deployment: {}", deploymentName);

        // Create Azure OpenAI Async Client
        OpenAIAsyncClient client = new OpenAIClientBuilder()
            .endpoint(azureOpenAiEndpoint)
            .credential(new AzureKeyCredential(azureOpenAiApiKey))
            .buildAsyncClient();

        // Create Azure OpenAI Chat Completion service
        ChatCompletionService chatCompletionService = OpenAIChatCompletion.builder()
            .withOpenAIAsyncClient(client)
            .withModelId(deploymentName)
            .build();

        // Create kernel plugins
        KernelPlugin itemKernelPlugin = KernelPluginFactory.createFromObject(
            itemPlugin,
            "ItemPlugin"
        );
        
        KernelPlugin stockKernelPlugin = KernelPluginFactory.createFromObject(
            stockPlugin,
            "StockPlugin"
        );
        
        KernelPlugin trackingKernelPlugin = KernelPluginFactory.createFromObject(
            trackingPlugin,
            "TrackingPlugin"
        );

        // Build and return the Kernel with the chat completion service and plugins
        Kernel kernel = Kernel.builder()
            .withAIService(ChatCompletionService.class, chatCompletionService)
            .withPlugin(itemKernelPlugin)
            .withPlugin(stockKernelPlugin)
            .withPlugin(trackingKernelPlugin)
            .build();
            
        logger.info("Semantic Kernel initialized with {} plugins", 3);
        return kernel;
    }
}
