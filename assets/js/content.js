/* PROFILE CONTENT
 * This is the single source of truth for profile data and project information.
 * Load this file before site.js. Keep the window.PORTFOLIO property name.
 * Use full https:// URLs for external links; leave optional links empty.
 * For a CV, add the PDF and set cv to its relative path, e.g. assets/documents/cv.pdf.
 * Keep the spelling and capitalization of existing asset paths.
 * Demo flags are preserved. Set demo to false when each project is ready for publication.
 * Add your actual responsibilities in the experience description below.
 * Names of people, institutions and places retain their original spelling.
 */
/* PROJECT BUTTONS
 * url: live Power BI report URL (existing links are preserved).
 * codeUrl: SQL file or repository URL for each project.
 * reportVideoUrl: video discussing the featured Power BI report.
 * sqlVideoUrl: video discussing the featured SQL code.
 * Empty links display disabled buttons marked Coming soon.
 * The first project is the featured project and has all four buttons.
 */
window.PORTFOLIO = {
  "name": "Paweł Bugowski",
  "role": "Data Analyst",
  "about": "I combine analytical thinking with business understanding. I turn complex data into clear insights that support better decisions.",
  "photo": "assets/images/autor.png",
  "photoAlt": "Paweł Bugowski — Data Analyst",
  "email": "pbugowski96@gmail.com",
  "linkedin": "https://www.linkedin.com/in/pawelbugowski/",
  "github": "https://github.com/PBugowski",
  "cv": "",
  "skills": [
    {
      "name": "SQL",
      "icon": "sql",
      "description": "Querying, joining and modeling data"
    },
    {
      "name": "Python",
      "icon": "python",
      "description": "Analysis, data processing and automation"
    },
    {
      "name": "Power BI",
      "icon": "power-bi",
      "description": "Dashboards, visualization and reporting"
    },
    {
      "name": "Excel",
      "icon": "excel",
      "description": "Analysis, pivot tables and Power Query"
    }
  ],
  "projects": [
    {
      "title": "NYC Accidents 2020",
      "demo": true,
      "description": "An interactive Power BI report exploring New York City accidents in 2020.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiOWIzYWE4NGYtZmI1OS00MWU1LThmYzktZDI4M2UwYmE3YmI0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "",
      "cover": "assets/projects/sales/cover.webp",
      "coverAlt": "NYC Accidents 2020 — cover image",
      "gallery": [
        {
          "src": "assets/projects/sales/gallery-01.webp",
          "thumb": "assets/projects/sales/gallery-01-thumb.webp",
          "alt": "NYC Accidents 2020 — dashboard screenshot 1"
        },
        {
          "src": "assets/projects/sales/gallery-02.webp",
          "thumb": "assets/projects/sales/gallery-02-thumb.webp",
          "alt": "NYC Accidents 2020 — dashboard screenshot 2"
        },
        {
          "src": "assets/projects/sales/gallery-03.webp",
          "thumb": "assets/projects/sales/gallery-03-thumb.webp",
          "alt": "NYC Accidents 2020 — dashboard screenshot 3"
        }
      ],
      "reportVideoUrl": "",
      "sqlVideoUrl": ""
    },
    {
      "title": "KajoDataSpace transactions for 2023 - 2026",
      "demo": true,
      "description": "An interactive Power BI report on KajoDataSpace transactions from 2023 to 2026.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiNGZjYmEwMDgtZGJhMS00ZGZjLWEyOWUtZDc3MmE0MmU0MzQ1IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "",
      "cover": "assets/projects/customers/cover.webp",
      "coverAlt": "KajoDataSpace transactions for 2023 - 2026 — cover image",
      "gallery": [
        {
          "src": "assets/projects/customers/gallery-01.webp",
          "thumb": "assets/projects/customers/gallery-01-thumb.webp",
          "alt": "KajoDataSpace transactions for 2023 - 2026 — dashboard screenshot 1"
        },
        {
          "src": "assets/projects/customers/gallery-02.webp",
          "thumb": "assets/projects/customers/gallery-02-thumb.webp",
          "alt": "KajoDataSpace transactions for 2023 - 2026 — dashboard screenshot 2"
        },
        {
          "src": "assets/projects/customers/gallery-03.webp",
          "thumb": "assets/projects/customers/gallery-03-thumb.webp",
          "alt": "KajoDataSpace transactions for 2023 - 2026 — dashboard screenshot 3"
        }
      ]
    },
    {
      "title": "Toys distribution in Mexico",
      "demo": true,
      "description": "An interactive Power BI report on toy distribution in Mexico.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiNjZmM2I0Y2QtNmYzMC00ODE4LWJiOTQtZDQzODA5MmIzN2Q0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "",
      "cover": "assets/projects/Maven/a1.png",
      "coverAlt": "Toys distribution in Mexico — cover image",
      "gallery": [
        {
          "src": "assets/projects/Maven/a2.png",
          "thumb": "assets/projects/Maven/a2.png",
          "alt": "Toys distribution in Mexico — dashboard screenshot 1"
        },
        {
          "src": "assets/projects/Maven/a3.png",
          "thumb": "assets/projects/Maven/a3.png",
          "alt": "Toys distribution in Mexico — dashboard screenshot 2"
        },
        {
          "src": "assets/projects/Maven/a4.png",
          "thumb": "assets/projects/Maven/a4.png",
          "alt": "Toys distribution in Mexico — dashboard screenshot 3"
        }
      ]
    }
  ],
  "experience": [
    {
      "title": "Process Engineer",
      "organization": "PRODMAX SP. Z O.O.",
      "period": "2020 - Present",
      "description": "Describe your responsibilities, the tools you used and a specific outcome of your work."
    }
  ],
  "education": [
    {
      "title": "P.G.D. in OHS",
      "organization": "Pawel Wlodkowic University College in Płock",
      "period": "2022 - 2023"
    },
    {
      "title": "M.A. in English",
      "organization": "Mazovian University in Płock",
      "period": "2018 - 2020"
    },
    {
      "title": "B.A. in English",
      "organization": "State University of Applied Sciences in Płock",
      "period": "2015 - 2018"
    }
  ],
  "certificates": [
    {
      "title": "Data Analytics, Data Science & Machine Learning",
      "organization": "Udemy",
      "period": "2026",
      "url": ""
    },
    {
      "title": "Docker Mastery: Kubernetes & Swarm",
      "organization": "Udemy",
      "period": "2025",
      "url": ""
    },
    {
      "title": "AWS Certified Cloud Practitioner (CCP)",
      "organization": "AWS",
      "period": "2025",
      "url": ""
    },
    {
      "title": "JavaScript Specialist: React & Redux",
      "organization": "CodersLab",
      "period": "2024",
      "url": ""
    },
    {
      "title": "Scrum Developer Certified (SDC)",
      "organization": "SCRUMstudy",
      "period": "2024",
      "url": ""
    },
    {
      "title": "Python Developer",
      "organization": "CodersLab",
      "period": "2024",
      "url": ""
    }
  ]
};
