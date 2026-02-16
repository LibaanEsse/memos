# Frontend build stage
FROM node:20-alpine AS frontend-builder
WORKDIR /web

ENV NRUN echo "Current dir:" && pwd
RUN echo "Contents:" && ls -R .
ENV NODE_OPTIONS="--max-old-space-size=4096"

COPY web/package*.json ./
RUN npm install

COPY web/ ./
RUN npm run build

# Backend build stage
FROM golang:1.22-alpine AS backend-builder

WORKDIR /app

RUN apk add --no-cache git

# Copy go mod files from app directory
COPY app/go.mod app/go.sum ./
RUN go mod download

# Copy entire backend source from app/
COPY app/ .

# Remove old frontend build (if exists)
RUN rm -rf server/router/frontend/dist || true

# Copy built frontend from frontend stage
COPY --from=frontend-builder /web/dist ./server/router/frontend/dist

# Build the Go binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o memos ./cmd/memos


# Runtime stage
FROM alpine:3.19

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy compiled binary
COPY --from=backend-builder /app/memos ./

RUN mkdir -p /var/opt/memos \
    && chown -R appuser:appgroup /var/opt/memos

ENV MEMOS_MODE=prod \
    MEMOS_DATA=/var/opt/memos \
    MEMOS_PORT=5230

USER appuser

EXPOSE 5230

CMD ["./memos"]

