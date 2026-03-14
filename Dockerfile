FROM golang:1.22 AS builder

WORKDIR /src

# Cache module downloads before copying the rest of the repo
COPY go.mod ./
RUN go mod download

# Copy the source tree, excluding runtime-only files via .dockerignore
COPY . .

# Sync module files before building
RUN go mod tidy

# Build the statically linked app binary
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/telegram-username-sniper ./cmd/app

# Keep config loading unchanged by placing a config.json symlink in the output dir
RUN ln -s /data/config.json /out/config.json

FROM gcr.io/distroless/static-debian12

# Copy the runtime artifacts into the final image
COPY --from=builder /out/ /app/

# Store session data and mounted config under /data
WORKDIR /data
VOLUME ["/data"]

ENTRYPOINT ["/app/telegram-username-sniper"]
