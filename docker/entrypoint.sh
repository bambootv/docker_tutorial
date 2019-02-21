#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /my_app/tmp/pids/server.pid

# Then exec the container's main process use CMD (what"s set as CMD in the Dockerfile).
exec "$@"
