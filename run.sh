#!/bin/bash
#
# e-Dockleracje -- zdokeryzowane e-Deklaracje
# Copyright (C) 2015 Michał "rysiek" Woźniak <rysiek@hackerspace.pl>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# upewniamy się, że działamy jako wrapper.sh, a więc już w dockerze
if [[ `basename $0` != 'wrapper.sh' ]]; then
  echo -ne '\n\nTen skrypt używany jest wyłącznie wewnątrz kontenera dockera;\njeśli chcesz uruchomić e-Deklaracje w dockerze,\nużyj skryptu edeklaracje.sh\n\n'
  exit 1
fi

# użytkownik i takie tam
groupadd -g "$EDEKLARACJE_GID" "$EDEKLARACJE_GROUP"
useradd -d "$EDEKLARACJE_HOME" -u "$EDEKLARACJE_UID" -g "$EDEKLARACJE_GID" -s /bin/bash "$EDEKLARACJE_USER"
mkdir -p "$EDEKLARACJE_HOME"

# akceptacja licencji Adobe Reader
mkdir -p $EDEKLARACJE_HOME/.adobe/Acrobat/9.0/Preferences
echo "<</AVPrivate [/c <<     /ChooseLangAtStartup [/b false]
        /EULAAcceptanceTime [/i 1]
        /SplashDisplayedAtStartup [/b false]
        /UnixLanguageStartup [/i 4542037]
        /showEULA [/b false]
>>]
>>" > $EDEKLARACJE_HOME/.adobe/Acrobat/9.0/Preferences/reader_prefs

chown -R "$EDEKLARACJE_UID":"$EDEKLARACJE_GID" "$EDEKLARACJE_HOME"

# ustawienie adresu ip hosta do CUPS
sed -i "s/HOST_IP/$HOST_IP/" /etc/cups/client.conf

exec su - $EDEKLARACJE_USER -c "
# magic: http://www.linuxquestions.org/questions/linux-newbie-8/xlib-connection-to-0-0-refused-by-server-xlib-no-protocol-specified-152556/
# na wszelki wypadek -- jeśli gid/uid/username się zgadzają, to powinno niby wszystko działać...
touch ~/.Xauthority
xauth add \$HOSTNAME/unix:0 $MIT_COOKIE
# jedziemy!
echo Docker: Uruchamiam e-Deklaracje...
echo
/opt/e-Deklaracje/bin/e-Deklaracje
"
