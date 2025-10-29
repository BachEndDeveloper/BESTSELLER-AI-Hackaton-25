import type { Message } from '../types/chat';
import './MessageBubble.css';

interface MessageBubbleProps {
  message: Message;
}

export const MessageBubble = ({ message }: MessageBubbleProps) => {
  const formatTime = (date: Date) => {
    return new Intl.DateTimeFormat('en-US', {
      hour: '2-digit',
      minute: '2-digit',
    }).format(date);
  };

  return (
    <div className={`message-bubble ${message.sender} ${message.isError ? 'error' : ''}`}>
      <div className="message-content">
        <pre className="message-text">{message.text}</pre>
        <span className="message-time">{formatTime(message.timestamp)}</span>
      </div>
    </div>
  );
};
