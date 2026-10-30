#!/bin/sh
set -eu

# Run only inside the newly approved, dedicated Debian container.
[ "$(id -u)" -eq 0 ] || { echo 'Run as root in the dedicated container.' >&2; exit 1; }
[ "$(hostname)" = 'nexo-pair' ] || { echo 'Refusing a host other than nexo-pair.' >&2; exit 1; }
unit=/etc/systemd/system/nexo-pairing.service
[ ! -e "$unit" ] || { echo 'Service already exists; inspect before an update.' >&2; exit 1; }
service_source=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/nexo-pairing.service
[ -f "$service_source" ] || { echo 'Missing service file.' >&2; exit 1; }

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl unzip
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM
archive="$work/rustdesk-server-linux-amd64.zip"
curl --fail --location --proto '=https' --tlsv1.2 \
  https://github.com/rustdesk/rustdesk-server/releases/download/1.1.16/rustdesk-server-linux-amd64.zip \
  -o "$archive"
printf '%s  %s\n' 0565c41affe6c3f409b0bddfaf5a24ccbf3f64f5f8e3fec250b69a0d5f6bdbcf "$archive" | sha256sum --check --status
entry=$(unzip -Z1 "$archive" | grep -E '(^|/)hbbs$')
[ "$(printf '%s\n' "$entry" | wc -l)" -eq 1 ] || { echo 'Ambiguous hbbs archive entry.' >&2; exit 1; }
unzip -p "$archive" "$entry" > "$work/hbbs"
install -d -m 0755 /usr/local/lib/nexo-pair
install -m 0755 "$work/hbbs" /usr/local/lib/nexo-pair/hbbs
# Intentionally do not extract or install hbbr, even though the upstream ZIP includes it.
if ! getent passwd nexo-pair >/dev/null; then
  useradd --system --home-dir /var/lib/nexo-pair --shell /usr/sbin/nologin nexo-pair
fi
install -o nexo-pair -g nexo-pair -d -m 0700 /var/lib/nexo-pair
install -m 0644 "$service_source" "$unit"
systemd-analyze verify "$unit"
systemctl daemon-reload
systemctl enable --now nexo-pairing.service
systemctl is-active --quiet nexo-pairing.service
test ! -e /usr/local/lib/nexo-pair/hbbr
printf '%s\n' 'Rendezvous service started. No relay installed. Exterior connectivity still requires a separate test.'
