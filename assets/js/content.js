/* Edit your profile, project links and qualifications here.
 * Empty SQL/video links show disabled Coming soon buttons.
 * Add your portrait under assets/images/ and update photo and photoAlt.
 * Add your CV PDF and update cv to show the download link.
 * Add a description of your responsibilities to experience[].description.
 * Demo flags preserve the existing portfolio labels.
 */
window.PORTFOLIO = {
  "name": "Paweł Bugowski",
  "role": "Data Analyst",
  "about": "I combine analytical thinking with business understanding. I turn complex data into clear insights that support better decisions.",
  "photo": "assets/images/autor.png",
  "photoAlt": "Profile photo placeholder for Paweł Bugowski",
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
      "description": "Exploring New York City traffic accidents in 2020: when and where collisions occur, who is affected, and which factors contribute to injuries.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiOWIzYWE4NGYtZmI1OS00MWU1LThmYzktZDI4M2UwYmE3YmI0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "",
      "cover": "assets/projects/nyc-accidents/cover.webp",
      "coverAlt": "NYC Accidents: Executive Overview",
      "gallery": [
        {
          "src": "assets/projects/nyc-accidents/gallery-01.webp",
          "thumb": "assets/projects/nyc-accidents/gallery-01-thumb.webp",
          "alt": "NYC Accidents: Accidents over Time",
          "title": "Accidents over Time"
        },
        {
          "src": "assets/projects/nyc-accidents/gallery-02.webp",
          "thumb": "assets/projects/nyc-accidents/gallery-02-thumb.webp",
          "alt": "NYC Accidents: Accident Locations",
          "title": "Accident Locations"
        },
        {
          "src": "assets/projects/nyc-accidents/gallery-03.webp",
          "thumb": "assets/projects/nyc-accidents/gallery-03-thumb.webp",
          "alt": "NYC Accidents: Accidents with Injuries",
          "title": "Accidents with Injuries"
        }
      ],
      "reportVideoUrl": "",
      "sqlVideoUrl": "",
      "coverTitle": "Executive Overview",
      "coverWidth": 1363,
      "coverHeight": 767
    },
    {
      "title": "KajoDataSpace Transactions",
      "demo": true,
      "description": "Analyzing subscription transactions from 2023 to 2026, with a focus on revenue, pricing changes, customer growth and cohort retention.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiNGZjYmEwMDgtZGJhMS00ZGZjLWEyOWUtZDc3MmE0MmU0MzQ1IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "",
      "cover": "assets/projects/kajodataspace-transactions/cover.webp",
      "coverAlt": "KajoDataSpace Transactions: Executive Overview",
      "gallery": [
        {
          "src": "assets/projects/kajodataspace-transactions/gallery-01.webp",
          "thumb": "assets/projects/kajodataspace-transactions/gallery-01-thumb.webp",
          "alt": "KajoDataSpace Transactions: Revenue and Discounts",
          "title": "Revenue and Discounts"
        },
        {
          "src": "assets/projects/kajodataspace-transactions/gallery-02.webp",
          "thumb": "assets/projects/kajodataspace-transactions/gallery-02-thumb.webp",
          "alt": "KajoDataSpace Transactions: Customer Growth",
          "title": "Customer Growth"
        },
        {
          "src": "assets/projects/kajodataspace-transactions/gallery-03.webp",
          "thumb": "assets/projects/kajodataspace-transactions/gallery-03-thumb.webp",
          "alt": "KajoDataSpace Transactions: Customer Cohort Retention",
          "title": "Customer Cohort Retention"
        }
      ],
      "coverTitle": "Executive Overview",
      "coverWidth": 1363,
      "coverHeight": 767
    },
    {
      "title": "Maven Toys — Sales & Inventory",
      "demo": true,
      "description": "Exploring sales and inventory across a toy retail business in Mexico: revenue drivers, product profitability and stock levels by category and location.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiNjZmM2I0Y2QtNmYzMC00ODE4LWJiOTQtZDQzODA5MmIzN2Q0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "",
      "cover": "assets/projects/maven-toys/cover.webp",
      "coverAlt": "Maven Toys: Sales and Inventory Overview",
      "gallery": [
        {
          "src": "assets/projects/maven-toys/gallery-01.webp",
          "thumb": "assets/projects/maven-toys/gallery-01-thumb.webp",
          "alt": "Maven Toys: Revenue Analysis",
          "title": "Revenue Analysis"
        },
        {
          "src": "assets/projects/maven-toys/gallery-02.webp",
          "thumb": "assets/projects/maven-toys/gallery-02-thumb.webp",
          "alt": "Maven Toys: Profit Analysis",
          "title": "Profit Analysis"
        },
        {
          "src": "assets/projects/maven-toys/gallery-03.webp",
          "thumb": "assets/projects/maven-toys/gallery-03-thumb.webp",
          "alt": "Maven Toys: Inventory Levels",
          "title": "Inventory Levels"
        }
      ],
      "coverTitle": "Sales and Inventory Overview",
      "coverWidth": 1352,
      "coverHeight": 767
    }
  ],
  "experience": [
    {
      "title": "Process Engineer",
      "organization": "PRODMAX SP. Z O.O.",
      "period": "2020 - Present",
      "description": ""
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
