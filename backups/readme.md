# Backups
## Server binary
You can find here original and cracked server binary files backups.

The default server binary used in this project is `cod2_lnxded_1_3_nodelay_va_loc`.

> Cracked server binary files credits goes to **Kung Foo Man** and **Mitch** from [Killtube](https://killtube.org/showthread.php?1719-Latest-cod2-linux-binaries-(1-0-1-2-1-3)).
It might be usefull if you want to create a public server to play on without a valid CD key ;-)

Custom server binary naming explanations (credits to **Mitch** on [this post](https://killtube.org/showthread.php?1337-CoD2-Tutorial-How-to-make-your-cracked-server-show-up-in-the-master-list&p=16844&viewfull=1#post16844)):
- "cracked": disable the master server + "nodelay"
- "nodelay": changes the minimum required master server offline time before you can connect to an original server (from ~30 minutes to 5 seconds)
- "loc": no spam of non-localized strings
- "va": patch for string overrun in call to va() function (more than 1024 chars), can be considered a security patch and should be used

## Library
The gcc3 library was used as a workaround on Ubuntu before finding a proper solution to add 32 bit gcc libraries using official repositories (issue dicussed [here](http://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit/454254#454254)). 

> It is not used anymore but will stay here as a backup, just in case it would be needed in the future.
