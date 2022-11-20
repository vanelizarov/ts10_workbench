#/bin/sh

./clean_local.sh
./import_original.sh
./unpack.sh
#./inject_su.sh
./inject_mods.sh
./inject_tweaks.sh
./repack.sh
./clean_local.sh
