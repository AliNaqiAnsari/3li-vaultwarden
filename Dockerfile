# 3LI Vaultwarden with Azure AD SSO
# Uses the official stable Vaultwarden image with built-in SSO support
FROM vaultwarden/server:1.35.4

# Ensure /data is treated as a persistent volume
VOLUME /data
