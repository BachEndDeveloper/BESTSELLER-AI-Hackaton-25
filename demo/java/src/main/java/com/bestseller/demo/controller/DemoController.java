package com.bestseller.demo.controller;

import com.bestseller.demo.service.SemanticKernelService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * REST controller demonstrating Semantic Kernel function calling.
 * Provides endpoints to invoke kernel functions and interact with the AI.
 */
@RestController
@RequestMapping("/api/demo")
public class DemoController {

    private final SemanticKernelService semanticKernelService;

    public DemoController(SemanticKernelService semanticKernelService) {
        this.semanticKernelService = semanticKernelService;
    }

    /**
     * Demonstrates direct kernel function invocation.
     * 
     * Example requests:
     * - GET /api/demo/function/ItemPlugin/getItemInfo?parameter=item-001
     * - GET /api/demo/function/StockPlugin/checkAvailability?parameter=item-002
     * - GET /api/demo/function/TrackingPlugin/getTrackingInfo?parameter=TRK-2025-001
     *
     * @param pluginName the name of the plugin
     * @param functionName the name of the function
     * @param parameter the parameter to pass
     * @return the function result
     */
    @GetMapping("/function/{pluginName}/{functionName}")
    public ResponseEntity<Map<String, String>> invokeFunction(
        @PathVariable String pluginName,
        @PathVariable String functionName,
        @RequestParam String parameter
    ) {
        String result = semanticKernelService.invokeKernelFunction(pluginName, functionName, parameter);
        return ResponseEntity.ok(Map.of(
            "plugin", pluginName,
            "function", functionName,
            "parameter", parameter,
            "result", result
        ));
    }

    /**
     * Demonstrates chat-based interaction with automatic function calling.
     * The AI will automatically call the appropriate kernel functions based on the user's message.
     * 
     * Example request body:
     * {
     *   "message": "Tell me about item-001"
     * }
     *
     * @param request the chat request with user message
     * @return the AI's response
     */
    @PostMapping("/chat")
    public ResponseEntity<Map<String, String>> chat(@RequestBody Map<String, String> request) {
        String userMessage = request.get("message");
        if (userMessage == null || userMessage.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of(
                "error", "Message is required"
            ));
        }

        String response = semanticKernelService.chat(userMessage);
        return ResponseEntity.ok(Map.of(
            "userMessage", userMessage,
            "aiResponse", response
        ));
    }

    /**
     * Health check endpoint.
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "message", "Semantic Kernel Demo is running"
        ));
    }

    /**
     * Provides information about available plugins and functions.
     */
    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> info() {
        return ResponseEntity.ok(Map.of(
            "description", "BESTSELLER Semantic Kernel Demo",
            "plugins", Map.of(
                "ItemPlugin", new String[]{
                    "getItemInfo - Get detailed item information by ID",
                    "searchItemsByCategory - Search items by category"
                },
                "StockPlugin", new String[]{
                    "getStockInfo - Get stock information by item ID",
                    "checkAvailability - Check if item is available"
                },
                "TrackingPlugin", new String[]{
                    "getTrackingInfo - Get tracking information by tracking number",
                    "getDeliveryStatus - Get delivery status by tracking number"
                }
            ),
            "endpoints", Map.of(
                "invokeFunction", "GET /api/demo/function/{pluginName}/{functionName}?parameter={value}",
                "chat", "POST /api/demo/chat with body: {\"message\": \"your question\"}",
                "health", "GET /api/demo/health",
                "info", "GET /api/demo/info"
            )
        ));
    }
}
