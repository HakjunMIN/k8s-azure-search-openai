# Build the frontend(node)
FROM node:14-alpine AS build-node
# RUN apt-get update && apt-get install -y bash
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend ./
RUN npm run build

# Runtime stage
FROM python:3.10-slim
RUN apt-get update && apt-get install -y bash
# Copy from build stages
COPY --from=build-node /app/ /app/frontend
# COPY --from=build-python /app/backend /app/backend  
WORKDIR /app
COPY backend ./backend
RUN python3 -m pip install -r backend/requirements.txt

COPY .env ./
COPY start-prod.sh ./

# Add user & define the added user as the USER
RUN useradd -u 1234 admin
USER admin
CMD ["/bin/bash", "-c", "source start-prod.sh"]