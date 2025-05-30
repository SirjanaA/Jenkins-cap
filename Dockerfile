# Use aws public image
FROM public.ecr.aws/docker/library/node:slim

# Copy application code.
COPY ./cpapp/events-api/ /app/

# Change the working directory
WORKDIR /app

# Install dependencies.
RUN npm install

# Start the Express app
CMD ["node", "server.js"]
