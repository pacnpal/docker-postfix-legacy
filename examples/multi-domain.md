# ==========================================================
# Multi-Domain Sender Routing
# ==========================================================
#
# Route different sender domains through different providers.
# Requires custom main.cf — use examples/docker-compose.custom.yml.
#
# 1. Uncomment in main.cf:
#    sender_dependent_relayhost_maps = hash:/etc/postfix/sender_relay
#    smtp_sender_dependent_authentication = yes
#    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd, hash:/etc/postfix/sender_sasl_passwd
#
# 2. Create sender_relay:
#    @company-a.com    [smtp.gmail.com]:587
#    @company-b.com    [email-smtp.us-east-1.amazonaws.com]:587
#
# 3. Create sender_sasl_passwd:
#    @company-a.com    alerts@company-a.com:gmail-app-password
#    @company-b.com    SES_SMTP_USER:SES_SMTP_PASS
#
# 4. Mount both files — entrypoint hashes them automatically.
