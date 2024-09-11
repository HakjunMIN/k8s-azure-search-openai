# Build the frontend(node)
FROM node:18-alpine AS build-node
# RUN apt-get update && apt-get install -y bash

COPY ./ /app

WORKDIR /app/frontend
RUN npm install
RUN npm run build

# Runtime stage
FROM python:3.10-slim

COPY --from=build-node /app/ /app/
# COPY --from=build-python /app/backend /app/backend  
WORKDIR /app

RUN python3 -m pip install -r backend/requirements.txt

CMD ["python3", "-m", "quart", "--app", "backend/main:app", "run", "--port", "80", "--host", "0.0.0.0"]