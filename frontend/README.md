# BESTSELLER Frontend - React TypeScript Chat Interface

A modern, responsive chat interface built with React and TypeScript that interacts with the BESTSELLER API.

## 🚀 Features

- **Modern Chat UI**: Beautiful, responsive chat interface with smooth animations
- **TypeScript**: Fully typed with TypeScript for better developer experience
- **API Integration**: Seamlessly integrates with BESTSELLER API endpoints:
  - View all items
  - Get item details
  - Check stock availability
  - Track orders
- **Smart Message Processing**: Natural language understanding for user queries
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Real-time Feedback**: Loading indicators and typing animations

## 📋 Prerequisites

- Node.js 20+ and npm
- BESTSELLER API running locally (or configured to remote server)

## 🛠️ Installation

1. Install dependencies:
```bash
npm install
```

2. Configure API endpoint (optional):
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env and set your API base URL if different from default
# VITE_API_BASE_URL=http://localhost:8080/v1
```

## 🚦 Running the Application

### Development Mode
```bash
npm run dev
```

This will start the development server at `http://localhost:5173`

### Build for Production
```bash
npm run build
```

### Preview Production Build
```bash
npm run preview
```

## 📁 Project Structure

```
frontend/
├── src/
│   ├── api/                 # Auto-generated API client from OpenAPI spec
│   ├── components/          # React components
│   │   ├── ChatWindow.tsx   # Main chat container
│   │   ├── MessageList.tsx  # Message list container
│   │   ├── MessageBubble.tsx # Individual message bubble
│   │   ├── ChatInput.tsx    # Input area with send button
│   │   └── TypingIndicator.tsx # Typing animation
│   ├── config/              # Configuration files
│   │   └── api.ts           # API client configuration
│   ├── services/            # Business logic
│   │   └── chatService.ts   # Chat message processing
│   ├── types/               # TypeScript type definitions
│   │   └── chat.ts          # Chat-related types
│   ├── App.tsx              # Main App component
│   ├── main.tsx             # Application entry point
│   └── index.css            # Global styles
├── public/                  # Static assets
├── openapi.yaml            # API specification (in parent directory)
└── package.json            # Dependencies and scripts
```

## 💬 Using the Chat Interface

The chat assistant understands natural language queries. Here are some examples:

### View Items
- "Show me all items"
- "List items"
- "What items do you have?"

### Get Item Details
- "Show item-001"
- "Get details for item-002"
- "Tell me about item 003"

### Check Stock
- "Check stock for item-001"
- "Is item-002 in stock?"
- "Stock item 001"

### Track Orders
- "Track TRK-2025-001234"
- "Order status TRK-2025-001235"
- "Where is my order TRK-2025-001234?"

### Help
- "help"
- "?"

## 🎨 Customization

### Styling
All component styles are in separate CSS files alongside their components. The design uses:
- CSS variables for consistent theming
- Modern CSS features (flexbox, animations, gradients)
- Responsive design with media queries

### API Configuration
Edit `src/config/api.ts` to customize the API client configuration:
```typescript
export const configureAPI = () => {
  OpenAPI.BASE = 'http://your-api-server/v1';
  // Add custom headers, authentication, etc.
};
```

### Environment Variables
Create a `.env` file with:
```
VITE_API_BASE_URL=http://localhost:8080/v1
```

## 🔧 Development

### Code Quality
```bash
# Run linter
npm run lint
```

### Type Checking
TypeScript is configured to check types during build. The project uses:
- Strict type checking
- Type-safe API client generated from OpenAPI spec
- Proper type definitions for all components

## 🚀 Deployment

### Build
```bash
npm run build
```

The build output will be in the `dist/` directory, ready to be deployed to any static hosting service (Netlify, Vercel, GitHub Pages, etc.).

### Environment Configuration
For production, set the `VITE_API_BASE_URL` environment variable to your production API endpoint.

## 📦 Dependencies

### Main Dependencies
- **React 19**: UI library
- **TypeScript**: Type safety
- **Vite**: Build tool and dev server
- **Axios**: HTTP client for API requests
- **openapi-typescript-codegen**: Generated TypeScript API client

### Dev Dependencies
- **ESLint**: Code linting
- **TypeScript ESLint**: TypeScript linting rules
- **Vite Plugin React**: React support for Vite

## 🤝 Contributing

1. Make changes to the code
2. Ensure TypeScript types are correct
3. Test the chat functionality with all API endpoints
4. Run `npm run lint` to check for issues
5. Build the project to ensure it compiles

## 📄 License

MIT License - see the main repository LICENSE file for details.

## 🆘 Troubleshooting

### API Connection Issues
- Ensure the backend API is running on `http://localhost:8080`
- Check the console for CORS errors
- Verify the API base URL in `.env` or `src/config/api.ts`

### Build Errors
- Clear node_modules: `rm -rf node_modules && npm install`
- Clear Vite cache: `rm -rf node_modules/.vite`
- Ensure you're using Node.js 20+

### TypeScript Errors
- Run `npm run build` to see all type errors
- Check that the API client was generated correctly
- Ensure all imports are correct

## 📞 Support

For issues or questions, please refer to the main repository documentation or open an issue.
