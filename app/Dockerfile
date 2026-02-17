# ----- Frontend build stage -----
FROM node:20-alpine AS frontend-builder

WORKDIR /web

# Copy package files and install deps
COPY web/package*.json ./
RUN npm install

# Copy frontend source and build
COPY web . 
RUN npm run build


# ----- Backend build stage -----
FROM golang:1.24 AS backend-builder

WORKDIR /app

# Only copy Go module files first for better caching
COPY go.mod go.sum .     
RUN go mod download

# Copy all source code
COPY . .                  
RUN ls -R /app
# Remove old frontend build if exists
RUN rm -rf server/router/frontend/dist

# Copy new frontend build from first stage
COPY --from=frontend-builder /web/dist ./server/router/frontend/dist

# Build the Go binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o memos ./cmd/memos


# ----- Runtime stage -----
FROM alpine:3.19

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the compiled Go binary
COPY --from=backend-builder /app/memos .

# Create data directory and give ownership
RUN mkdir -p /var/opt/memos && \
    chown -R appuser:appgroup /var/opt/memos

# Environment variables
ENV MEMOS_MODE=prod \
    MEMOS_DATA=/var/opt/memos \
    MEMOS_PORT=5230

USER appuser

EXPOSE 5230

# Default entrypoint
CMD ["./memos"]


