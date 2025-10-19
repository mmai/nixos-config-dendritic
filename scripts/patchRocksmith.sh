# cf. https://github.com/theNizo/linux_rocksmith/blob/main/guides/setup/nixos/legacy.md

HOME="/home/henri"
PROTONVER="Proton - Experimental"
STEAMLIBRARY="/run/media/henri/LexarExt4/SteamLibrary"
PROTONPATH="$HOME/.steam/steam/steamapps/common/$PROTONVER/files" # For proton 9.0 and Experimental
WINEPREFIX="$STEAMLIBRARY/steam/steamapps/compatdata/221680/pfx"

# à executer depuis shell `steam-run bash`
# cp "/lib/wine/i386-unix/wineasio32.dll.so" "$PROTONPATH/lib/wine/i386-unix/wineasio32.dll.so"
# cp "/lib/wine/x86_64-unix/wineasio64.dll.so" "$PROTONPATH/lib/wine/x86_64-unix/wineasio64.dll.so"
