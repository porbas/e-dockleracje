FROM ubuntu:13.10

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install x11-apps xauth wget xvfb
RUN dpkg --add-architecture i386 && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install libgtk2.0-0:i386 libstdc++6:i386 libnss3-1d:i386 lib32nss-mdns libxml2:i386 libxslt1.1:i386 libxslt1.1 libcanberra-gtk-module:i386 gtk2-engines-murrine:i386 libqt4-qt3support:i386 libgnome-keyring0:i386

RUN ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0 /usr/lib/libgnome-keyring.so.0
RUN ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0.2.0 /usr/lib/libgnome-keyring.so.0.2.0

RUN wget -O /opt/air.bin http://airdownload.adobe.com/air/lin/download/latest/AdobeAIRInstaller.bin && chmod +x /opt/air.bin
RUN xvfb-run /opt/air.bin -silent -eulaAccepted

# via http://ask.xmodulo.com/install-adobe-reader-ubuntu-13-10.html
RUN wget http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb
RUN DEBIAN_FRONTEND=noninteractive dpkg -i --force-architecture AdbeRdr9.5.5-1_i386linux_enu.deb
# license? ~/.adobe? /opt/Adobe/Reader9/Reader/GlobalPrefs/reader_prefs? elsewhere?

RUN wget -O /opt/edeklaracje.air http://www.finanse.mf.gov.pl/documents/766655/1196444/e-DeklaracjeDesktop.air
RUN xvfb-run '/opt/Adobe AIR/Versions/1.0/Adobe AIR Application Installer' -silent -eulaAccepted /opt/edeklaracje.air

ENV DISPLAY :0
ADD run.sh /opt/run.sh
RUN chmod a+x /opt/run.sh
WORKDIR /opt

RUN echo "Run with: XSOCK=/tmp/.X11-unix/X0; -v $XSOCK:$XSOCK"

ENTRYPOINT ["/opt/run.sh"]