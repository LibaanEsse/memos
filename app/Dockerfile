# Frontend build stage
FROM node:20-alpine AS frontend-builder
WORKDIR /web

# Allow Node more memory to avoid heap out-of-memory errors
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Copy package files and install dependencies
COPY web/package*.json ./
RUN npm install

# Copy frontend source code
COPY web .

# Build the frontend
RUN npm run build


# Backend build stage
FROM golang:1.25-alpine AS backend-builder
WORKDIR /app
COPY ["go.mod", "go.sum", "./"]
RUN go mod download
COPY . .
RUN rm -rf server/router/frontend/dist
COPY --from=frontend-builder /web/dist ./server/router/frontend/dist
RUN CGO_ENABLED=0 GOOS=linux go build -o memos ./cmd/memos


# Runtime Stage
FROM alpine:3.19
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=backend-builder /app/memos .
RUN mkdir -p /var/opt/memos \
  && chown -R appuser:appgroup /var/opt/memos

ENV MEMOS_MODE=prod \
    MEMOS_DATA=/var/opt/memos \
    MEMOS_PORT=5230

USER appuser
EXPOSE 5230

CMD ["./memos"]
