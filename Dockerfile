FROM alpine:3.21

LABEL maintainer="Talor Hammond"
LABEL description="Minimal Postfix relay for legacy SMTP devices. No auth/TLS inbound, authenticated outbound."
LABEL org.opencontainers.image.description="Minimal Postfix relay for legacy SMTP devices, vintage computers, and retro software. Accepts plain SMTP on port 25, relays outbound through modern providers with TLS and authentication."
LABEL org.opencontainers.image.source="https://github.com/pacnpal/docker-postfix-legacy"

RUN apk add --no-cache \
    postfix \
    postfix-pcre \
    cyrus-sasl \
    cyrus-sasl-login \
    ca-certificates \
    tzdata \
    mailx

RUN postalias /etc/postfix/aliases || true

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD postfix status || exit 1

ENTRYPOINT ["/entrypoint.sh"]
