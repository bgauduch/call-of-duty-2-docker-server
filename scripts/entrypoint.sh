#!/bin/sh
set -euo pipefail

# launch server 
LD_PRELOAD="/lib/libcod2_1_3.so" /server/cod2_lnxded +set fs_basepath "/server" +set fs_homepath "/home" +exec config.cfg

# tail server logs in foreground
# tail -f -n 50 /home/main/games_mp.log