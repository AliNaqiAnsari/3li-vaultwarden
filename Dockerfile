# 3LI Custom Vaultwarden with SSO Auto-Redirect
# This Dockerfile builds a custom Vaultwarden image with automatic SSO redirect

# Stage 1: Build the custom web vault
FROM node:22-bookworm AS web-vault-build

WORKDIR /build

# Copy the modified web vault source
COPY web-vault/web-vault /build/web-vault

# Build the web vault
WORKDIR /build/web-vault
RUN npm ci
WORKDIR /build/web-vault/apps/web
RUN npm run dist:oss:selfhost

# Stage 2: Use the official Vaultwarden testing image as base
FROM vaultwarden/server:testing

# Copy the custom web vault into the Vaultwarden image
COPY --from=web-vault-build /build/web-vault/apps/web/build /web-vault

# The default entrypoint and command are inherited from the base image
