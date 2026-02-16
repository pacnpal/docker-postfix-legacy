# ==========================================================
# Provider Examples
# ==========================================================
# Copy the env vars for your provider into docker-compose.yml.


# ---- Forward Email ----
# SMTP_RELAY_HOST=smtp.forwardemail.net
# SMTP_RELAY_PORT=587
# SMTP_USERNAME=you@yourdomain.com
# SMTP_PASSWORD=your-password
#
# Notes: Domain must be verified in Forward Email dashboard.


# ---- Gmail / Google Workspace ----
# SMTP_RELAY_HOST=smtp.gmail.com
# SMTP_RELAY_PORT=587
# SMTP_USERNAME=you@gmail.com
# SMTP_PASSWORD=your-app-password
#
# Notes: Must use App Password (https://myaccount.google.com/apppasswords).
#        2FA required. ~500 msgs/day free, ~2000 Workspace.


# ---- Microsoft 365 / Outlook ----
# SMTP_RELAY_HOST=smtp.office365.com
# SMTP_RELAY_PORT=587
# SMTP_USERNAME=you@yourdomain.com
# SMTP_PASSWORD=your-password
#
# Notes: Enable "SMTP AUTH" in Exchange Admin for the mailbox.
#        Use App Password if MFA is enabled.


# ---- Amazon SES ----
# SMTP_RELAY_HOST=email-smtp.us-east-1.amazonaws.com
# SMTP_RELAY_PORT=587
# SMTP_USERNAME=YOUR_SES_SMTP_USERNAME
# SMTP_PASSWORD=YOUR_SES_SMTP_PASSWORD
#
# Notes: SMTP creds are NOT your AWS keys — generate in SES console.
#        New accounts start in sandbox mode. ~$0.10/1000 emails.
