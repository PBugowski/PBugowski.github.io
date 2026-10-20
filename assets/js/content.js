/* EDYTUJ TUTAJ SWOJE DANE. Zachowaj cudzysłowy, przecinki i nawiasy.
   Puste linki pozostają nieaktywne. Nie wpisuj tu haseł ani kluczy API.
   Zrzuty i opisy projektów poniżej są demonstracyjne. */
window.PORTFOLIO = {
  name: "Imię Nazwisko",
  role: "Analityk danych",
  about: "Łączę analityczne myślenie ze zrozumieniem biznesu. Pomagam zamieniać złożone dane w czytelne wnioski, które wspierają podejmowanie lepszych decyzji. Tutaj dodaj kilka zdań o swoim doświadczeniu, zainteresowaniach i podejściu do pracy z danymi.",
  photo: "assets/images/avatar-placeholder.svg",
  photoAlt: "Miejsce na zdjęcie autora",
  email: "", // np. kontakt@twojadomena.pl — bez mailto:
  linkedin: "", // pełny adres https://www.linkedin.com/in/...
  github: "", // pełny adres https://github.com/...
  cv: "", // np. assets/documents/cv.pdf; dodaj również sam plik PDF

  skills: [
    {name: "SQL", icon: "sql", description: "Zapytania, łączenie i modelowanie danych"},
    {name: "Python", icon: "python", description: "Analiza, przetwarzanie i automatyzacja"},
    {name: "Power BI", icon: "power-bi", description: "Dashboardy, wizualizacje i raportowanie"},
    {name: "Excel", icon: "excel", description: "Analizy, tabele przestawne i Power Query"}
  ],
  projects: [
    {
      title: "Analiza sprzedaży", demo: true,
      description: "Przykładowy dashboard sprzedażowy: trendy przychodów, porównanie wyników i szczegóły zamówień. Podmień ten opis na swój problem biznesowy, sposób analizy i najważniejszy wniosek.",
      tools: ["SQL", "Power BI"], url: "", codeUrl: "",
      cover: "assets/projects/sales/cover.webp", coverAlt: "Przykładowy dashboard analizy sprzedaży",
      gallery: [
        {src: "assets/projects/sales/gallery-01.webp", thumb: "assets/projects/sales/gallery-01-thumb.webp", alt: "Przykładowe wyniki sprzedaży w kolejnych miesiącach"},
        {src: "assets/projects/sales/gallery-02.webp", thumb: "assets/projects/sales/gallery-02-thumb.webp", alt: "Przykładowe porównanie wyników sprzedaży"},
        {src: "assets/projects/sales/gallery-03.webp", thumb: "assets/projects/sales/gallery-03-thumb.webp", alt: "Tabela z syntetycznymi danymi zamówień"}
      ]
    },
    {
      title: "Segmentacja klientów", demo: true,
      description: "Przykładowa analiza grup klientów i retencji. Miejsce na opis Twojej segmentacji, zastosowanych metod oraz rekomendacji biznesowych.",
      tools: ["Python", "Pandas"], url: "", codeUrl: "",
      cover: "assets/projects/customers/cover.webp", coverAlt: "Przykładowy dashboard segmentacji klientów",
      gallery: [
        {src: "assets/projects/customers/gallery-01.webp", thumb: "assets/projects/customers/gallery-01-thumb.webp", alt: "Wykres rozkładu przykładowych segmentów klientów"},
        {src: "assets/projects/customers/gallery-02.webp", thumb: "assets/projects/customers/gallery-02-thumb.webp", alt: "Przykładowa mapa retencji kohort"},
        {src: "assets/projects/customers/gallery-03.webp", thumb: "assets/projects/customers/gallery-03-thumb.webp", alt: "Tabela z syntetycznymi danymi klientów"}
      ]
    },
    {
      title: "Skuteczność kampanii", demo: true,
      description: "Przykładowy raport efektywności działań marketingowych. Miejsce na Twoją analizę konwersji, kosztów pozyskania i skuteczności kanałów.",
      tools: ["SQL", "Excel"], url: "", codeUrl: "",
      cover: "assets/projects/campaigns/cover.webp", coverAlt: "Przykładowy dashboard skuteczności kampanii",
      gallery: [
        {src: "assets/projects/campaigns/gallery-01.webp", thumb: "assets/projects/campaigns/gallery-01-thumb.webp", alt: "Przykładowe porównanie wyników kampanii"},
        {src: "assets/projects/campaigns/gallery-02.webp", thumb: "assets/projects/campaigns/gallery-02-thumb.webp", alt: "Przykładowa struktura kanałów marketingowych"},
        {src: "assets/projects/campaigns/gallery-03.webp", thumb: "assets/projects/campaigns/gallery-03-thumb.webp", alt: "Przykładowy lejek konwersji"}
      ]
    }
  ],
  experience: [
    {title: "Twoje stanowisko", organization: "Nazwa firmy", period: "Okres zatrudnienia", description: "Opisz swój zakres obowiązków, używane narzędzia oraz konkretny rezultat pracy."},
    {title: "Poprzednie stanowisko", organization: "Nazwa firmy", period: "Okres zatrudnienia", description: "Dodaj poprzednie doświadczenie. Możesz dowolnie dodawać lub usuwać wpisy."}
  ],
  education: [
    {title: "Kierunek studiów", organization: "Nazwa uczelni", period: "Lata nauki"},
    {title: "Studia podyplomowe", organization: "Nazwa uczelni", period: "Lata nauki"},
    {title: "Profil kształcenia", organization: "Nazwa szkoły", period: "Lata nauki"},
    {title: "Kolejny kierunek / szkoła", organization: "Nazwa instytucji", period: "Lata nauki"}
  ],
  certificates: [
    {title: "Nazwa certyfikatu", organization: "Organizacja wydająca", period: "Rok", url: ""},
    {title: "Kolejny certyfikat", organization: "Organizacja wydająca", period: "Rok", url: ""},
    {title: "Kolejny certyfikat", organization: "Organizacja wydająca", period: "Rok", url: ""},
    {title: "Kolejny certyfikat", organization: "Organizacja wydająca", period: "Rok", url: ""}
  ]
};
