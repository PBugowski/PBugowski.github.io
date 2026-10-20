window.PORTFOLIO = {
  name: "Paweł Bugowski",
  role: "Data Analyst",
  about: "Łączę analityczne myślenie ze zrozumieniem biznesu. Pomagam zamieniać złożone dane w czytelne wnioski, które wspierają podejmowanie lepszych decyzji. Tutaj dodaj kilka zdań o swoim doświadczeniu, zainteresowaniach i podejściu do pracy z danymi.",
  photo: "assets/images/avatar-placeholder.svg",
  photoAlt: "assets/images/autor.png",
  email: "pbugowwski96@gmail.com",
  linkedin: "https://www.linkedin.com/in/pawelbugowski/",
  github: "https://github.com/PBugowski",
  cv: "", // np. assets/documents/cv.pdf; dodaj również sam plik PDF

  skills: [
    {name: "SQL", icon: "sql", description: "Zapytania, łączenie i modelowanie danych"},
    {name: "Python", icon: "python", description: "Analiza, przetwarzanie i automatyzacja"},
    {name: "Power BI", icon: "power-bi", description: "Dashboardy, wizualizacje i raportowanie"},
    {name: "Excel", icon: "excel", description: "Analizy, tabele przestawne i Power Query"}
  ],
  projects: [
    {
      title: "NYC Accidents 2020", demo: true,
      description: "Przykładowy dashboard sprzedażowy: trendy przychodów, porównanie wyników i szczegóły zamówień. Podmień ten opis na swój problem biznesowy, sposób analizy i najważniejszy wniosek.",
      tools: ["SQL", "Power BI"], url: "https://app.powerbi.com/view?r=eyJrIjoiOWIzYWE4NGYtZmI1OS00MWU1LThmYzktZDI4M2UwYmE3YmI0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9", codeUrl: "",
      cover: "assets/projects/sales/cover.webp", coverAlt: "Przykładowy dashboard analizy sprzedaży",
      gallery: [
        {src: "assets/projects/sales/gallery-01.webp", thumb: "assets/projects/sales/gallery-01-thumb.webp", alt: "Przykładowe wyniki sprzedaży w kolejnych miesiącach"},
        {src: "assets/projects/sales/gallery-02.webp", thumb: "assets/projects/sales/gallery-02-thumb.webp", alt: "Przykładowe porównanie wyników sprzedaży"},
        {src: "assets/projects/sales/gallery-03.webp", thumb: "assets/projects/sales/gallery-03-thumb.webp", alt: "Tabela z syntetycznymi danymi zamówień"}
      ]
    },
    {
      title: "KajoDataSpace transactions for 2023 - 2026", demo: true,
      description: "Przykładowa analiza grup klientów i retencji. Miejsce na opis Twojej segmentacji, zastosowanych metod oraz rekomendacji biznesowych.",
      tools: ["SQL", "Power BI"], url: "https://app.powerbi.com/view?r=eyJrIjoiNGZjYmEwMDgtZGJhMS00ZGZjLWEyOWUtZDc3MmE0MmU0MzQ1IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9", codeUrl: "",
      cover: "assets/projects/customers/cover.webp", coverAlt: "Przykładowy dashboard segmentacji klientów",
      gallery: [
        {src: "assets/projects/customers/gallery-01.webp", thumb: "assets/projects/customers/gallery-01-thumb.webp", alt: "Wykres rozkładu przykładowych segmentów klientów"},
        {src: "assets/projects/customers/gallery-02.webp", thumb: "assets/projects/customers/gallery-02-thumb.webp", alt: "Przykładowa mapa retencji kohort"},
        {src: "assets/projects/customers/gallery-03.webp", thumb: "assets/projects/customers/gallery-03-thumb.webp", alt: "Tabela z syntetycznymi danymi klientów"}
      ]
    },
    {
      title: "Toys distribution in Mexico", demo: true,
      description: "Przykładowy raport efektywności działań marketingowych. Miejsce na Twoją analizę konwersji, kosztów pozyskania i skuteczności kanałów.",
      tools: ["SQL", "Power BI"], url: "https://app.powerbi.com/view?r=eyJrIjoiNjZmM2I0Y2QtNmYzMC00ODE4LWJiOTQtZDQzODA5MmIzN2Q0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9", codeUrl: "",
      cover: "assets/projects/Maven/a1.png", coverAlt: "Przykładowy dashboard skuteczności kampanii",
      gallery: [
        {src: "assets/projects/Maven/a2.png", thumb: "assets/projects/campaigns/gallery-01-thumb.webp", alt: "Przykładowe porównanie wyników kampanii"},
        {src: "assets/projects/Maven/a3.png", thumb: "assets/projects/campaigns/gallery-02-thumb.webp", alt: "Przykładowa struktura kanałów marketingowych"},
        {src: "assets/projects/Maven/a4.png", thumb: "assets/projects/campaigns/gallery-03-thumb.webp", alt: "Przykładowy lejek konwersji"}
      ]
    }
  ],
  experience: [
    {title: "Process Engineer", organization: "PRODMAX SP. Z O.O.", period: "2020 - Present", description: "Opisz swój zakres obowiązków, używane narzędzia oraz konkretny rezultat pracy."},
  ],
  education: [
    {title: "P.G.D. in OHS", organization: "Pawel Wlodkowic University College in Płock", period: "2022 - 2023"},
    {title: "M.A. in English", organization: "Mazovian University in Płock", period: "2018 - 2020"},
    {title: "B.A. in English", organization: "State University of Applied Sciences in Płock", period: "2015 - 2018"}
  ],
  certificates: [
    {title: "Data Analytics, Data Science & Machine Learning", organization: "Udemy", period: "2026", url: ""},
    {title: "Docker Mastery: Kubernetes & Swarm", organization: "Udemy", period: "2025", url: ""},
    {title: "AWS Certified Cloud Practitioner (CCP)", organization: "AWS", period: "2025", url: ""},
    {title: "JavaScript Specialist: React & Redux", organization: "CodersLab", period: "2024", url: ""},
    {title: "Scrum Developer Certified (SDC)", organization: "SCRUMstudy", period: "2024", url: ""},
    {title: "Python Developer", organization: "CodersLab", period: "2024", url: ""}
  ]
};
