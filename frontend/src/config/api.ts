import { OpenAPI } from '../api';

// Configure the API client
export const configureAPI = () => {
  // Use local development server by default, can be overridden by environment variable
  OpenAPI.BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/v1';
  
  // You can add more configuration here if needed
  // For example, authentication tokens, custom headers, etc.
};
