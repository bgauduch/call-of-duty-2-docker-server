#!/bin/sh
set -euo pipefail

# launch server using libcod library
LD_PRELOAD='/lib/libcod2_1_3.so' ./cod2_lnxded +exec config.cfg
# +set fs_basepath "/server" +set fs_homepath "/server/home"

# tail server logs in foreground
# tail -f -n 50 /home/main/games_mp.log
