# docker-postfix-legacy

A minimal Postfix relay for legacy SMTP devices. Accepts plain SMTP (no auth, no TLS) on port 25, relays outbound through your provider with proper authentication.

Built for printers, scanners, HVAC controllers, NAS boxes, security cameras, and anything else that only speaks plain SMTP. Also works great as a relay for vintage computers and retro software — old versions of Outlook, Outlook Express, Eudora, Thunderbird, Fedora, Red Hat, Windows XP/2000, and other systems whose TLS stacks are too outdated to talk to modern mail providers directly.

```
┌──────────────┐    port 25      ┌─────────────────┐    port 587       ┌──────────────┐
│ Legacy Device │ ─── no auth ──▶│ postfix-legacy  │ ── TLS + auth ──▶│ Gmail / SES  │
│ (plain SMTP) │   no TLS       │ (this container) │   SASL           │ O365 / etc.  │
└──────────────┘                 └─────────────────┘                   └──────────────┘
```

## Quick Start

```yaml
# docker-compose.yml
services:
  postfix:
    image: pacnpal/postfix-legacy:latest
    container_name: postfix-relay
    restart: unless-stopped
    ports:
      - "25:25"
    environment:
      - TZ=America/New_York
      - SMTP_HOSTNAME=mail.example.com
      - SMTP_DOMAIN=example.com
      - SMTP_RELAY_HOST=smtp.gmail.com
      - SMTP_RELAY_PORT=587
      - SMTP_USERNAME=you@gmail.com
      - SMTP_PASSWORD=your-app-password
```

```bash
docker compose up -d
```

That's it.

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `SMTP_HOSTNAME` | `localhost` | FQDN of this relay server |
| `SMTP_DOMAIN` | `localdomain` | Your sending domain |
| `SMTP_RELAY_HOST` | *(required)* | Provider's SMTP server |
| `SMTP_RELAY_PORT` | `587` | Provider's SMTP port |
| `SMTP_USERNAME` | *(required)* | Relay auth username |
| `SMTP_PASSWORD` | *(required)* | Relay auth password |
| `SMTP_NETWORKS` | `127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16` | Trusted networks (RFC1918) |
| `SMTP_OUTBOUND_TLS` | `encrypt` | Outbound TLS level (`encrypt`, `may`, `none`) |
| `SMTP_MESSAGE_SIZE` | `52428800` | Max message size in bytes (50MB) |
| `TZ` | *(none)* | Container timezone |

## Provider Quick Reference

**Gmail:** `SMTP_RELAY_HOST=smtp.gmail.com` — requires [App Password](https://myaccount.google.com/apppasswords)

**Microsoft 365:** `SMTP_RELAY_HOST=smtp.office365.com` — enable SMTP AUTH in Exchange Admin

**Amazon SES:** `SMTP_RELAY_HOST=email-smtp.us-east-1.amazonaws.com` — generate SMTP creds in SES console

**Forward Email:** `SMTP_RELAY_HOST=smtp.forwardemail.net` — verify domain in dashboard

See [`examples/providers.md`](examples/providers.md) for detailed notes.

## Advanced: Custom main.cf

For full control, mount your own config and skip env var generation entirely:

```yaml
volumes:
  - ./my-main.cf:/etc/postfix/main.cf.custom:ro
  - ./my-sasl_passwd:/etc/postfix/sasl_passwd:ro
```

The entrypoint detects `main.cf.custom` and uses it instead of generating from env vars. See [`examples/`](examples/) for templates including [multi-domain routing](examples/multi-domain.md).

## Testing

```bash
# Telnet test
telnet localhost 25
HELO test
MAIL FROM:<sender@example.com>
RCPT TO:<recipient@example.com>
DATA
Subject: Test
This is a test.
.
QUIT

# Check logs
docker logs postfix-relay
```

## Security

This container accepts unauthenticated, unencrypted SMTP — that's the point. Keep it safe:

- **Don't expose port 25 to the internet.** This is an open relay for anything in `SMTP_NETWORKS`.
- **Tighten `SMTP_NETWORKS`** to your actual subnets.
- **Use a dedicated relay account**, not your primary email.
- **Use `docker compose` secrets or `.env` files** instead of inline passwords.

## License

MIT
