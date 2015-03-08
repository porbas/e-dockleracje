#!/bin/bash

echo "The argument was: $1"

# magic: http://www.linuxquestions.org/questions/linux-newbie-8/xlib-connection-to-0-0-refused-by-server-xlib-no-protocol-specified-152556/
xauth add $HOSTNAME/unix:0 $1
/opt/e-Deklaracje/bin/e-Deklaracje