# Use the official Node.js image
FROM node:18-slim
WORKDIR /app

# Copy the application
COPY . .

# Install Node.js dependencies 
# RUN npm install

# Run the JavaScript application
CMD ["node", "challenge.js", "../artefakter"]
