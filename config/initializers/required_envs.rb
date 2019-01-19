# Won't allow app to start if these keys aren't defined.
# See https://github.com/laserlemon/figaro#required-keys

Figaro.require_keys(
  "AUTH0_DOMAIN",
  "AUTH0_CLIENT_ID",
  "AUTH0_CLIENT_SECRET",
  "ELASTICSEARCH_URL",
  "FORCE_LOGIN_PASSWORD",
  "HOSTNAME",
  "ROLLBAR_ACCESS_TOKEN",
  "S3_BUCKET",
  "S3_ACCESS_KEY_ID",
  "S3_SECRET_ACCESS_KEY",
  "SMTP_HOST",
  "SMTP_USERNAME",
  "SMTP_PASSWORD",
  "SUPPORT_EMAIL"
)
