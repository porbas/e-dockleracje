#!/bin/bash

echo -ne '

e-Dockleracje
-------------
e-Deklaracje w dockerze

'

# X cookie -- konieczne do poprawnego działania X serwera
COOKIE=`xauth list $DISPLAY | sed -r -e 's/^.+MIT/MIT/'`

# socket X servera
XSOCK="/tmp/.X11-unix/X0"

# nazwa obrazu dockera
IMAGE_NAME="edeklaracje"

# nazwa kontenera
CONTAINER_NAME="$IMAGE_NAME"

# katalog z konfiguracją eDeklaracji na lokalnym hoście i w dockerze
EDEKLARACJE_CONFDIR="$HOME/.eDeklaracje"
EDEKLARACJE_DOCKDIR="/.eDeklaracje"

# mamy dockera?
if ! docker --version >/dev/null; then
  echo -ne '\nNie znalazłem dockera -- czy jest zainstalowany?\n\n'
  exit 1
fi

# czy istnieje już obraz o nazwie $IMAGE_NAME?
if docker inspect edeklaracje >/dev/null; then
  # używamy go, czy budujemy od nowa?
  echo -n "Istnieje zbudowany obraz $IMAGE_NAME. Budować mimo to? (T/n) "
  read BUILD
  if [[ $BUILD != 'n' ]]; then
    echo -ne '\nBuduję obraz...\n\n'
    docker build -t $IMAGE_NAME ./
    echo -ne '\nObraz zbudowany.\n\n'
  else
    echo -ne '\nUżywam istniejącego obrazu.\n\n'
  fi

# nope
else
  # budujemy!
  echo -ne '\nBuduję obraz...\n\n'
  docker build -t $IMAGE_NAME ./
  echo -ne '\nObraz zbudowany.\n\n'
fi

# czy przypadkiem nie ma uruchomionego innego dockera z tą samą nazwą?
if [[ `docker inspect -f '{{.State}}' "$CONTAINER_NAME"` != '<no value>' ]]; then
  echo -ne "Wygląda na to, że kontener $CONTAINER_NAME istnieje; zatrzymuję/niszczę, by móc uruchomić na nowo.\n\n"
  docker stop "$CONTAINER_NAME"
  docker rm -v "$CONTAINER_NAME"
fi

# jedziemy
echo -ne "\nUruchamiam kontener $CONTAINER_NAME...\n\n"
docker run --rm -ti \
  -v "$XSOCK":"$XSOCK" \
  -v "$EDEKLARACJE_CONFDIR":"$EDEKLARACJE_DOCKDIR" \
  -e EDEKLARACJE_USER="$USER" \
  -e EDEKLARACJE_UID="` id -u $USER `" \
  -e EDEKLARACJE_GID="` id -g $USER `" \
  -e EDEKLARACJE_GROUP="` id -gn $USER `" \
  -e EDEKLARACJE_HOME="$HOME" \
  -e MIT_COOKIE="$COOKIE" \
  -e DISPLAY="$DISPLAY" \
  --name $CONTAINER_NAME $IMAGE_NAME 