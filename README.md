# Portfolio analityka danych — GitHub Pages

Kompletna statyczna strona w HTML, CSS i JavaScript. Zawiera wszystkie potrzebne grafiki i lokalne fonty. Nie wymaga Node.js, npm, frameworka ani kompilacji do opublikowania. Można ją umieścić w repozytorium GitHub Pages.

**Najpierw otwórz `INSTRUKCJA.html`** — zawiera instrukcję krok po kroku, personalizację oraz rozwiązywanie najczęstszych problemów.

## Szybki start

1. Rozpakuj ZIP. Otwórz `index.html`, aby obejrzeć stronę lokalnie.
2. Edytuj `assets/js/content.js`: imię, opis, zdjęcie, e-mail, profile, projekty, doświadczenie, szkoły i certyfikaty.
3. W `index.html` uzupełnij tytuł i metadane.
4. Utwórz publiczne repozytorium `TWOJ_LOGIN.github.io` (najprostszy adres) lub użyj repozytorium `portfolio`.
5. Prześlij **zawartość** katalogu strony, tak aby `index.html` i `assets/` leżały bezpośrednio w głównym katalogu repozytorium. Nie przesyłaj ZIP-a jako jednego pliku.
6. W Settings → Pages ustaw Source: Deploy from a branch, Branch: main, Folder: /(root), następnie Save.

## Najważniejsze pliki

| Plik / folder | Rola |
| --- | --- |
| `index.html` | Struktura strony, nagłówki i metadane |
| `assets/js/content.js` | Wszystkie Twoje dane i wpisy |
| `assets/js/site.js` | Galerie, menu mobilne, kontakt i renderowanie danych |
| `assets/css/site.css` | Układ i wygląd strony na różnych ekranach |
| `assets/css/tokens.css` | Kolory, fonty i zmienne projektu |
| `assets/images/` | Tło hero i placeholder zdjęcia |
| `assets/projects/` | Okładki i galerie trzech projektów |
| `assets/brand/` | Favicony, znak i podgląd społecznościowy |
| `assets/fonts/` | Lokalne fonty oraz licencja |
| `assets/icons/` | Edytowalne ikony SVG; strona korzysta z kopii sprite inline w HTML |
| `.nojekyll` | Wyłącza domyślną obróbkę Jekyll dla plików strony |
| `INSTRUKCJA.html` | Szczegółowa instrukcja do otwarcia w przeglądarce |

## Gotowe funkcje

- Responsywna nawigacja z menu mobilnym.
- Analityczne tło na całą szerokość hero.
- Okrągłe zdjęcie, opis, CV i ikony kontaktowe.
- Każdy projekt: okładka oraz oddzielna galeria; powiększenie w dialogu, strzałki, Escape i powrót fokusu.
- Oddzielne listy doświadczenia, edukacji i certyfikatów; po trzech kwalifikacjach przycisk rozwijania dalszych pozycji.
- Kontakt przez linki i formularz otwierający program pocztowy.
- Obsługa ograniczenia animacji, etykiety formularza i widoczny fokus klawiatury.

## Kontakt

Uzupełnij `email` w `content.js`. Dopóki jest pusty, formularz pozostaje wyłączony. Po uzupełnieniu przycisk **Otwórz e-mail** uruchamia program pocztowy odwiedzającego z imieniem, adresem zwrotnym i treścią. Użytkownik wysyła wiadomość sam w programie pocztowym.

To nie jest automatyczna wysyłka po stronie serwera. GitHub Pages hostuje pliki statyczne. Jeśli później zechcesz wysyłać bez otwierania poczty, trzeba podłączyć usługę formularzy; ten kod nie udaje wysłania wiadomości.

## Przykładowe materiały

Dashboardy są ilustracjami z danymi syntetycznymi. Nie przedstawiają Twoich rzeczywistych wyników. Każdy przykładowy projekt ma `demo: true` i widoczną etykietę. Zmień to na `false` dopiero po dodaniu własnego projektu. Szkoły, stanowiska i certyfikaty w pliku danych są opisowymi placeholderami.

## Weryfikacja

Sprawdzono składnię plików JavaScript, konfigurację treści, kompletność plików obrazów, odwołania HTML/CSS/JS oraz strukturę archiwum. Układ posiada reguły dla komputerów, tabletów i telefonów.

Test wizualny i interakcyjny w przeglądarce nie został wykonany — środowisko podglądu było niedostępne. Po opublikowaniu sprawdź listę kontrolną z instrukcji: menu na telefonie, galerie i powrót fokusu, formularz z własnym adresem oraz brak poziomego przewijania.

## Pochodzenie zasobów

Tło hero wygenerowano dla tego projektu. Dashboardy, logo i rysunki SVG przygotowano jako edytowalne zasoby. Nazwy i symbole serwisów służą identyfikacji odnośników; znaki należą do ich właścicieli. Ikony narzędzi są symboliczne. Fonty DejaVu mają dołączony plik licencji `assets/fonts/LICENSE-DejaVu.txt` — zachowaj go.

Dokumentacja GitHub sprawdzona 20.10.2026:

- https://docs.github.com/en/pages/quickstart
- https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site
- https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository
- https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages
