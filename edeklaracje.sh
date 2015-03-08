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