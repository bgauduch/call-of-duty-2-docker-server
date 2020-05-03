#!/usr/bin/env sh

set -eo

chown -v -R cod2:cod2 "/home/${SERVER_USER}/main"
./cod2_lnxded
