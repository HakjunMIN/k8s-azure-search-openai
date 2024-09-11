# Build the frontend(node)
FROM node:18-alpine AS build-node

COPY ./ /app
WORKDIR /app/frontend
RUN npm install
RUN npm run build

# Runtime stage
FROM python:3.10-slim
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /app
COPY --from=build-node /app/ /app/

RUN chown -R appuser:appgroup /app

USER appuser

RUN python3 -m venv /app/venv && \
    /app/venv/bin/pip install --no-cache-dir -r /app/backend/requirements.txt

ENV PATH="/app/venv/bin:$PATH"

CMD ["python3", "-m", "quart", "--app", "backend/main:app", "run", "--port", "8080", "--host", "0.0.0.0"]