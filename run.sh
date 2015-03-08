#!/bin/bash

# upewniamy się, że działamy jako wrapper.sh, a więc już w dockerze
if [[ `basename $0` != 'wrapper.sh' ]]; then
  echo -ne '\n\nTen skrypt używany jest wyłącznie wewnątrz kontenera dockera;\njeśli chcesz uruchomić e-Deklaracje w dockerze,\nużyj skryptu edeklaracje.sh\n\n'
  exit 1
fi

# użytkownik i takie tam
groupadd -g "$EDEKLARACJE_GID" "$EDEKLARACJE_GROUP"
useradd -d "$EDEKLARACJE_HOME" -u "$EDEKLARACJE_UID" -g "$EDEKLARACJE_GID" -s /bin/bash "$EDEKLARACJE_USER"
mkdir -p "$EDEKLARACJE_HOME"
chown -R "$EDEKLARACJE_UID":"$EDEKLARACJE_GID" "$EDEKLARACJE_HOME"

exec su - $EDEKLARACJE_USER -c "
# magic: http://www.linuxquestions.org/questions/linux-newbie-8/xlib-connection-to-0-0-refused-by-server-xlib-no-protocol-specified-152556/
#xauth add \$HOSTNAME/unix:0 $MIT_COOKIE
#/opt/e-Deklaracje/bin/e-Deklaracje
/bin/bash
"