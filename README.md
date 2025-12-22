# 3LI Vaultwarden - Custom SSO Auto-Redirect

This is a customized Vaultwarden deployment with automatic SSO redirect to Azure AD.

## Features

- **Automatic SSO Redirect**: Users are automatically redirected to Azure AD login without needing to enter an SSO identifier
- **No Email Prompt**: Bypasses the email entry screen entirely
- **Seamless Authentication**: One-click login experience for 3LI users

## Configuration

The SSO configuration is embedded in the web vault at build time:

```javascript
window.VW_SSO_CONFIG = {
  defaultIdentifier: '3li',
  autoRedirect: true
};
```

## Building

### Prerequisites
- Docker

### Build the custom image

```bash
docker build -t 3li-vaultwarden:latest .
```

## Deployment

This image is deployed on Coolify at `https://pass.3li.global`

### Required Environment Variables

The following SSO environment variables should be set in Coolify:

- `SSO_ENABLED=true`
- `SSO_CLIENT_ID=<your-azure-client-id>`
- `SSO_CLIENT_SECRET=<your-azure-client-secret>`
- `SSO_AUTHORITY=https://login.microsoftonline.com/<tenant-id>/v2.0`
- `SSO_SCOPES=openid email profile offline_access`
- `SSO_ONLY=true`
- `SSO_SIGNUPS_MATCH_EMAIL=true`
- `SSO_PKCE=true`

## Customization

To change the SSO identifier, modify the `defaultIdentifier` value in:
- `web-vault/web-vault/apps/web/src/index.html`

Then rebuild the Docker image.

## Based On

- [Vaultwarden](https://github.com/dani-garcia/vaultwarden) - The unofficial Bitwarden server
- [Vaultwarden Web Builds](https://github.com/dani-garcia/bw_web_builds) - Web vault builds for Vaultwarden
