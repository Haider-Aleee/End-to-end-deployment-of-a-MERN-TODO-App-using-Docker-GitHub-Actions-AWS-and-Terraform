FROM node:18-alpine

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Set build-time environment variable for Vite
ARG VITE_API_BASE_URL
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL

# Build the production bundle
RUN npm run build

# Install serve globally to serve the built files
RUN npm install -g serve

EXPOSE 3000

# Serve the built static files
CMD ["serve", "-s", "dist", "-l", "3000"]

