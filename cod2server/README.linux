Call Of Duty 2(tm)
Linux Multiplayer Server Code
Version 1.3
Readme
Last update: 2006-06-14
=============================

!! IMPORTANT !!
 Call of Duty 2(tm) Linux Server is NOT SUPPORTED by Activision(r) Customer
 Support. Please do not call with any questions related to this free beta
 product. There are other channels to aid you listed at the bottom of this
 document.


===============================================

TABLE OF CONTENTS

1. Introduction
2. Upgrading to 1.3.
3. Installation From Scratch
4. Support Channels
5. FreeBSD Note

===============================================


1. Introduction

 This document explains how to install the Call of Duty 2(tm) Linux server
 version 1.3. Installation from scratch and upgrading an existing installation
 are both covered.

 Usage is very similar to Call of Duty(tm) and United Offensive(tm)... many
 of the console commands, command lines, and cvars are identical, so if you
 are comfortable maintaining dedicated servers for those games, you will find
 this process familiar.

 MOD USERS: PLEASE READ...
  It is recommended that any user modifications that have been
  installed to the Call of Duty 2(tm) directory be removed before
  installing this package. These modifications are not supported
  by Activision(r) and may not be compatible with some of the new
  features that are included. When installing or upgrading a server,
  if problems or unexpected behavior arise, your first step in
  troubleshooting should be to do a clean install with the original
  data files.

 IF YOU HAVE A PROBLEM WITH "LIBSTDC++.SO.5" ...
  (This is a frequent-enough problem to merit discussion in the introduction.)

  If you are reading this, it's probably because you tried to start your Linux
   server and saw this message:

    ./cod2_lnxded: error while loading shared libraries: libstdc++.so.5:
     cannot open shared object file: No such file or directory

  COD2 is a C++ program built with gcc 3.3.4, which means it needs a
  system library specific to gcc 3.3. Older Linux systems won't have
  this installed, and we're starting to see newer Linux distributions that
  don't have this either, since they are supplying an incompatible
  gcc 3.4 version. The good news is that you can drop the needed library
  into your system without breaking anything else.

  Here is the library you need, if your Linux distribution doesn't supply it:
    http://icculus.org/updates/cod/gcc3-libs.tar.bz2

  You want to unpack that somewhere that the dynamic linker will see it
  (if you are sure it won't overwrite any files, you can even use /lib).

  The brave can put it in the same directory as the game and run the server
  like this:
     LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. ./cod2_lnxded

  Now the server will start.

2. Upgrading to 1.3

 Just stop the game server, replace cod2_lnxded, etc on your server with the
  files included in this package, and restart the game server.


3. Installation From Scratch

 - Get the retail Call of Duty 2(tm) disc(s) (there may be multiple discs
   depending on what edition of the game you have obtained, or perhaps a
   single DVD-ROM disc).
 - Copy the contents of disc ones "Setup/Data" directory to wherever you
   want to install the Call of Duty 2(tm) Linux server. There should be a
   "localization.txt" file in the root of this directory, and a "Main"
   Subdirectory.  Each additional disc should be opened and the contents of
   each "Data" folder should be copied over to the existing Main folder. When
   you have copied everything, the final installation size is around 3.5
   gigabytes.
 - Alternately, you may install on Windows(r) and copy the installed game to
   your Linux system, but many will opt to skip this step since the data
   files are uncompressed and easily accessible on the discs. Final
   installation size is around 3.5 gigabytes.
 - Unpack this archive in the root of the newly-copied tree, so
   "cod2_lnxded" is in the same directory as "localization.txt". Unlike the
   original Call of Duty(tm), there are not seperate .so files like
   "game.mp.i386.so", so don't be concerned when you don't see them.
 - Now, run the server:
     cd /where/i/copied/callofduty2
     ./cod2_lnxded

 - When you see "--- Common Initialization Complete ---", the game
   server has started, but you need to start a map before the server will
   accept connections. At this point, type:

     map mp_leningrad

   ("mp_leningrad" being a given map's name).

 - Now you should see your server in the in-game browser. You will now want to
   customize your server, but that is beyond the scope of this document.


4. Support Channels

 There are a LOT of knobs you can tweak to customize and automate your server,
 but it is beyond the scope of this documentation. Please refer to the
 admin manuals for any Quake 3(tm) based Multiplayer game (including Quake 3
 Arena(tm), Return to Castle Wolfenstein(tm), the original Call of Duty(tm)
 and United Offensive(tm), etc) for specifics.

 There is a mailing list for discussion and support of Linux servers for all
 of the Call of Duty(tm) games and expansion packs. Hundreds of experienced
 server admins and even some of the game's developers monitor this list, and
 are eager to help with politely asked questions. Send a blank email to
 cod-subscribe@icculus.org to get on the list, and list archives can be seen
 at:

   http://icculus.org/cgi-bin/ezmlm/ezmlm-cgi?38

 Bug reports should NOT be sent to the list. We have a web-based
 bugtracking system for this. If you don't report bugs there, we don't
 promise to even be aware of them, let alone fix them! You can find the bug
 tracker here:

   https://bugzilla.icculus.org/


 Also, http://callofduty.com/ and http://infinityward.com/ may direct you to
 important information, documentation and current news about Call of Duty(tm)
 titles.


5.  FreeBSD users

 This server is known to work on FreeBSD with the Linux binary compatibility
 layer. If it doesn't, we consider it a bug and appreciate the report since we
 won't necessarily be testing on FreeBSD ourselves. Please note that the
 game server requires that you use at least the linux_base-8 package for
 binary compatibility (it has a C++ runtime library we now need that previous
 linux_base packages don't supply...alternately, see notes about libstdc++ in
 this document's introduction if you can't or won't update linux_base).

// end of README.linux ...

