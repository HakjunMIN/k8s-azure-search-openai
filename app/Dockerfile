# Build the frontend(node)
FROM node:18-alpine AS build-node
# RUN apt-get update && apt-get install -y bash
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend ./
RUN npm run build

# Runtime stage
FROM python:3.10-slim

COPY --from=build-node /app/ /app/frontend
# COPY --from=build-python /app/backend /app/backend  
WORKDIR /app
COPY backend ./backend


# COPY start-prod.sh ./

# WORKDIR /app/backend
RUN python3 -m pip install -r requirements.txt

CMD ["python3", "-m", "quart", "--app", "backend/main:app", "run", "--port", "80", "--host", "0.0.0.0"]