# 3LI Custom Vaultwarden with SSO Auto-Redirect
# This Dockerfile builds a custom Vaultwarden image with automatic SSO redirect
# Based on the official bw_web_builds Dockerfile

# Stage 1: Build the custom web vault
FROM node:22-bookworm AS web-vault-build

# Install git for version info
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /bw_web_builds

# Copy the modified web vault source (already includes 3LI SSO patches)
COPY web-vault/web-vault ./web-vault

# Copy Vaultwarden resources for branding
COPY web-vault/resources/src ./resources

# Build the web vault
WORKDIR /bw_web_builds/web-vault
RUN npm ci

WORKDIR /bw_web_builds/web-vault/apps/web
RUN npm run dist:oss:selfhost

# Rename build output to web-vault (matches official structure)
RUN mv build /bw_web_builds/web-vault-dist

# Copy Vaultwarden-specific resources
WORKDIR /bw_web_builds
RUN cp -f resources/favicon.ico web-vault-dist/favicon.ico 2>/dev/null || true
RUN cp -rf resources/images/* web-vault-dist/images/ 2>/dev/null || true

# Ensure css directory exists and create vaultwarden.css placeholder
RUN mkdir -p web-vault-dist/css && touch web-vault-dist/css/vaultwarden.css

# Create vw-version.json for version tracking
RUN printf '{"version":"3li-custom"}' > web-vault-dist/vw-version.json

# Stage 2: Use the official Vaultwarden testing image as base
FROM vaultwarden/server:testing

# Copy the custom web vault into the Vaultwarden image
# The official Vaultwarden expects web vault at /web-vault
COPY --from=web-vault-build /bw_web_builds/web-vault-dist /web-vault

# The default entrypoint and command are inherited from the base image
