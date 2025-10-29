# BESTSELLER Chat Frontend

A modern, responsive chat interface built with React and TypeScript that interacts with the BESTSELLER API endpoints for managing items, stock, and tracking information.

## 🚀 Features

- **Modern Chat Interface**: Clean, intuitive chat UI with message history
- **API Integration**: Connects to Items, Stock, and Tracking endpoints
- **Natural Language Processing**: Simple keyword-based message interpretation
- **Rich Data Display**: Beautiful, responsive cards for different data types:
  - Item listings and details
  - Stock availability information
  - Package tracking with history
- **Real-time Feedback**: Loading states, error handling, and success messages
- **Responsive Design**: Works seamlessly on desktop and mobile devices
- **TypeScript**: Full type safety with TypeScript interfaces matching OpenAPI spec

## 🛠️ Technology Stack

- **React 18** - Modern UI framework
- **TypeScript** - Type-safe development
- **Vite** - Lightning-fast build tool
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client for API calls
- **Lucide React** - Beautiful icon library

## 📋 Prerequisites

- Node.js 18+ and npm 9+
- A running instance of the BESTSELLER API backend (Java/Spring, .NET/Aspire, or Python/FastAPI)

## 🏁 Getting Started

### Installation

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure the API endpoint:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and set your API base URL:
   ```
   VITE_API_BASE_URL=http://localhost:8080/v1
   ```

### Running the Development Server

```bash
npm run dev
```

The application will be available at `http://localhost:5173`

### Building for Production

```bash
npm run build
```

The production-ready files will be in the `dist/` directory.

### Preview Production Build

```bash
npm run preview
```

## 💬 Using the Chat Interface

The chat assistant understands various commands:

### List All Items
```
Show me all items
List items
What items do you have?
```

### Get Item Details
```
Tell me about item-001
Show details for item-002
What is item-003?
```

### Check Stock
```
Is item-001 in stock?
Check stock for item-002
What's the availability of item-003?
```

### Track Shipment
```
Track TRK-2025-001234
Where is my package TRK-2025-001235?
Tracking status for TRK-2025-001236
```

## 🏗️ Project Structure

```
frontend/
├── src/
│   ├── components/          # React components
│   │   ├── ChatWindow.tsx   # Main chat container
│   │   ├── ChatMessage.tsx  # Individual message component
│   │   └── ChatInput.tsx    # Message input field
│   ├── services/            # API and business logic
│   │   ├── api.ts           # API client (axios)
│   │   └── chat.ts          # Chat message processing
│   ├── types/               # TypeScript definitions
│   │   └── api.ts           # API types matching OpenAPI spec
│   ├── App.tsx              # Root component
│   ├── main.tsx             # Application entry point
│   └── index.css            # Global styles (Tailwind)
├── public/                  # Static assets
├── index.html               # HTML template
├── vite.config.ts           # Vite configuration
├── tailwind.config.js       # Tailwind CSS configuration
├── tsconfig.json            # TypeScript configuration
└── package.json             # Dependencies and scripts
```

## 🎨 Customization

### Styling

The application uses Tailwind CSS. Modify `tailwind.config.js` to customize:
- Colors
- Spacing
- Typography
- Breakpoints

### API Endpoints

Update `src/services/api.ts` to:
- Change the base URL
- Add authentication headers
- Modify request/response interceptors

### Chat Logic

Modify `src/services/chat.ts` to:
- Add new command patterns
- Improve message interpretation
- Integrate AI/LLM for natural language understanding

## 🔧 Development

### Type Safety

All API responses are typed according to the OpenAPI specification. Types are defined in `src/types/api.ts`.

### Code Quality

The project uses ESLint for code quality. Run linting:

```bash
npm run lint
```

### Hot Module Replacement (HMR)

Vite provides instant feedback during development. Changes are reflected immediately without full page reloads.

## 📦 Dependencies

### Core Dependencies
- `react` - UI framework
- `react-dom` - React DOM rendering
- `axios` - HTTP client
- `lucide-react` - Icon library
- `tailwindcss` - CSS framework

### Development Dependencies
- `vite` - Build tool
- `typescript` - Type checking
- `@vitejs/plugin-react` - React support for Vite
- ESLint and related plugins - Code quality

## 🔒 Security

- Environment variables for API configuration
- No hardcoded API keys or secrets
- Input sanitization for user messages
- Error messages don't expose sensitive information

## 🌐 Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## 📝 API Integration

The frontend expects the backend API to conform to the OpenAPI specification in `../openapi.yaml`:

- `GET /items` - List all items
- `GET /items/{itemId}` - Get item details
- `GET /stock/{itemId}` - Get stock information
- `GET /track/{trackingNo}` - Get tracking status

## 🚧 Troubleshooting

### CORS Issues

If you encounter CORS errors, ensure your backend API allows requests from `http://localhost:5173` during development.

### API Connection Errors

1. Verify the backend server is running
2. Check the `VITE_API_BASE_URL` in your `.env` file
3. Ensure the API endpoints match the OpenAPI specification

### Build Errors

1. Clear node_modules: `rm -rf node_modules package-lock.json`
2. Reinstall: `npm install`
3. Clear Vite cache: `rm -rf .vite`

## 🤝 Contributing

1. Follow the existing code structure
2. Use TypeScript types for all data
3. Follow the established component patterns
4. Test with different screen sizes
5. Ensure accessibility (keyboard navigation, screen readers)

## 📄 License

This project is part of the BESTSELLER AI Hackathon 2025 repository.

## 🎉 Acknowledgments

- Built with modern React best practices
- Follows chat interface UX patterns
- Responsive design for all devices
- TypeScript for type safety

