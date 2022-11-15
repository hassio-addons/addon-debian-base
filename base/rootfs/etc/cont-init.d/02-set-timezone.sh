#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Base Images
# Configures the timezone
# ==============================================================================

bashio::log.info "Configuring timezone"

ln --symbolic --no-dereference --force "/usr/share/zoneinfo/${TZ}" /etc/localtime
echo "${TZ}" > /etc/timezone
