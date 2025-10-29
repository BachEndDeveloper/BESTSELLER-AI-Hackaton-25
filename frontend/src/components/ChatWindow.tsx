import { useState, useRef, useEffect } from 'react';
import { MessageList } from './MessageList';
import { ChatInput } from './ChatInput';
import type { Message } from '../types/chat';
import { processUserMessage } from '../services/chatService';
import './ChatWindow.css';

export const ChatWindow = () => {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: '1',
      text: 'Hello! I\'m the BESTSELLER assistant. I can help you with:\n\n• Viewing available items\n• Checking stock for specific items\n• Tracking your orders\n\nTry asking me something like "Show me all items" or "Check stock for item-001"',
      sender: 'bot',
      timestamp: new Date(),
    },
  ]);
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSendMessage = async (text: string) => {
    const userMessage: Message = {
      id: Date.now().toString(),
      text,
      sender: 'user',
      timestamp: new Date(),
    };

    setMessages((prev) => [...prev, userMessage]);
    setIsLoading(true);

    try {
      const botResponse = await processUserMessage(text);
      const botMessage: Message = {
        id: (Date.now() + 1).toString(),
        text: botResponse,
        sender: 'bot',
        timestamp: new Date(),
      };
      setMessages((prev) => [...prev, botMessage]);
    } catch (error) {
      const errorMessage: Message = {
        id: (Date.now() + 1).toString(),
        text: `Sorry, I encountered an error: ${error instanceof Error ? error.message : 'Unknown error'}`,
        sender: 'bot',
        timestamp: new Date(),
        isError: true,
      };
      setMessages((prev) => [...prev, errorMessage]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="chat-window">
      <div className="chat-header">
        <h1>BESTSELLER Assistant</h1>
        <p>Your AI-powered shopping companion</p>
      </div>
      <MessageList messages={messages} isLoading={isLoading} />
      <div ref={messagesEndRef} />
      <ChatInput onSend={handleSendMessage} disabled={isLoading} />
    </div>
  );
};
