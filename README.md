# TS10-Firmware-Workbench

---

## This is a fork of [mariodantas](https://github.com/mariodantas)'s workbench.

Originally posted on [XDA](https://forum.xda-developers.com/t/tool-topway-ts10-firmware-workbench.4287089/).
What changed:
1. Added option to `config.ini` to specify custom unpacked firmaware parts' names:
    ```bash
   FIRMWAREID="<name of any of .0 ... .3 files without extension>"
   ```
2. Added ability to run scripts from Docker (for macOS compatibility). To use docker, place unpacked firmware files inside `orig` folder and then run:
   ```bash
   # Build image
   ./docker.sh build
   
   # Runs container and starts interactive shell
   ./docker.sh run
   
   # Inside container enter superuser mode
   su
   
   # Exec scripts as usual, i.e. to create fw with preinstalled root:
   ./import_original.sh
   ./unpack.sh
   ./inject_su.sh
   ./repack.sh # Patched firmware files will appear in `patched` folder
   ```
---

Scripts intended to mount the Topway TS10 Firmware, make modifications and reassemble the firmware
They can retrieve the firmware from specified location and after modification, they can put the firmware into another specified location

Files:

1-) config.ini = A file to setup parameters, paths for the original firmware and patched firmware, temp directory to work with firmware files and mount point to edit the firmware

2-) import_original.sh = Retrieves the files .0 .1 .2 and .3 from the location specified in config.ini

3-) import_patched.sh = Retrieves the same files that 'import_original.sh' but from the patched location specified in the config.ini (normally a firmware that you've already patched before)

4-) unpack.sh = Unpack the imported firmware and create the mount moint (as specified in the config.ini file) to work with the firmware

5-) repack.sh = Unmount the modified firmware from the mount point, delete the mount point, split the firmware in files .0 .1 .2 and .3 and move it to the patched directory as specified in config.ini

6-) inject_tweaks.sh = Modify locale, dataroaming and remove (if necessary) the values in ro.fota.device to avoid message "UI unauthorized, please contact the supplier"

7-) inject_mods.sh = This will copy all the contents of the '_mods' folder inside firmware. I.E. I put a 'gps_debug.cfg' inside 'system/etc/' and it will be injected into firmware overwritting the existent

8-) inject_su.sh = This will inject su binary into firmware as a daemon, this is dangerous as the firmware is permanently rooted and the apps don't ask for permissions (they already have the root access) USE AT YOUR OWN RISK

9-) clean_local.sh = This script will unmount the firmware and delete it, it will also delete temporary files. as its name says, it cleans the dir !

10-) run_all.sh = Does all the tasks as follows: import from-original, unpack, inject su, mods, tweaks, repack and publish to patched foldern the clean local folders and exit

External (included) tools:

tools/twt (Topwaytool) forked from https://github.com/mkotyk/topwaytool

_mods folder containing a sample file 'gps_debug.cfg'



N'joy it !


MarioDANTAS (XDA member: mariodantas)
