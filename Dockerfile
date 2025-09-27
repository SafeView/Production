# syntax=docker/dockerfile:1

# This Dockerfile is a placeholder at the Production root.
# It is NOT used to build or run the application stack.
# Use: `docker compose up --build` which builds each service
# from its own Dockerfile under ./services/*.

FROM alpine:3.20
LABEL org.opencontainers.image.title="safeview-production root placeholder"
LABEL org.opencontainers.image.description="Root-level Dockerfile placeholder. Use docker compose to build and run the stack."
LABEL org.opencontainers.image.source="https://example.local/safeview-production"

WORKDIR /stack
COPY docker-compose.yml ./

CMD ["sh", "-c", "echo 'This is a placeholder image. Use: docker compose up --build' && sleep 3600"]

