# e-Dockleracje

Michał "rysiek" Woźniak opracował spsób uruchomienia e-Deklaracji pod linuxem przy wykorzystaniu dockera: http://rys.io/pl/150.

# Moje zmiany:
* można wydrukować formularze bezpośrenio z e-Deklaracji. UWAGA - musisz zmodyfikować konfigurację CUPS hosta zgodnie z info: http://stackoverflow.com/questions/31030609/printing-from-inside-a-docker-container
      ...
      Listen *:631
      ...
      <Location />
        Order allow,deny
        Allow all
      </Location>
      ...

* licencja Adobe Reader jest akceptowana podczas budowania kontenera. Nie musisz tego robić przy każdym uruchomieniu e-Deklaracji
