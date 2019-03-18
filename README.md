# e-Dockleracje

Michał "rysiek" Woźniak opracował sposób uruchomienia e-Deklaracji pod Linuxem przy wykorzystaniu Dockera.
Jego oryginalne repozytorium jest nadal dostępne pod adresem: https://code.hackerspace.pl/rysiek/e-dockleracje/.

Oryginalny opis był na stronie http://rys.io/pl/150. Obecnie (marzec 2019) link nie działa, na http://rys.io mamy informację "rys.io wróci niebawem"

# Instrukcja użycia

```
git clone https://github.com/porbas/e-dockleracje
cd e-dockleracje
./edeklaracje.sh
```

# Aktualizacja e-deklaracji

Po uruchomieniu aplikacji możesz dostać infrmację, że jest dostępna nowsza wersja. Nie aktualizuj z poziomu aplikacji!
Aby zaktualizować zakończ pracę i ponownie uruchochm skrypt `edekraracje.sh`.
Odpowiedz twierdząco na pytanie:

    "Istnieje zbudowany obraz edeklaracje_lts. Budować mimo to? (t/N)"

Wówczas zostanie pobrana i zainstalowana nowsza wersja e-deklaracji.

# Zmiany w stosunku do pierwotnej wersji "ryśka"

* można wydrukować formularze bezpośrenio z e-Deklaracji. UWAGA - musisz zmodyfikować konfigurację CUPS hosta zgodnie z info: http://stackoverflow.com/questions/31030609/printing-from-inside-a-docker-container
```
# /etc/cups/cupsd.conf
...
Listen *:631
...
<Location />
  Order allow,deny
  Allow all
</Location>
...
```
* licencja Adobe Reader jest akceptowana podczas budowania kontenera. Nie musisz tego robić przy każdym uruchomieniu e-Deklaracji
