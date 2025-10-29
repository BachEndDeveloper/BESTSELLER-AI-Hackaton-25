# Multi-stage build for BESTSELLER Frontend
# Stage 1: Build the React application
FROM node:20 AS builder

# Set working directory
WORKDIR /app

# Set environment to avoid optional dependencies issues
ENV NODE_ENV=production

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install dependencies - using npm install as npm ci has issues in some Docker environments  
RUN npm install --production=false

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the application with nginx
FROM nginx:alpine

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
