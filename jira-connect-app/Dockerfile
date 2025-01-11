# Use the official Node.js image as a base
FROM node:18

# Set the working directory inside the container
WORKDIR /opt

# Copy package.json and package-lock.json to the container
#COPY package*.json ./

# Install dependencies inside the container
#RUN npm install

# Copy the rest of your application files to the container
#COPY . .

# Expose the application port (e.g., 3000)
EXPOSE 8080

# Specify the command to run your app
CMD ["node", "index.js"]
