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
  "photo": "assets/images/avatar-placeholder.svg",
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
      "coverHeight": 767,
      "descriptionDetails": "The report examines accident patterns across months, weekdays and times of day, including a timeline of COVID-19 restrictions. Geographic views compare boroughs and roads, while the injury analysis explores road-user groups, vehicle types and contributing factors.\n\nUse the live report to explore the available date, borough and vehicle-type filters. The gallery highlights the time analysis, location analysis and injury dashboard."
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
      "coverWidth": 1280,
      "coverHeight": 720,
      "descriptionDetails": "The report compares revenue by subscription type and the share of transactions at regular and discounted prices. Customer views place new-customer counts and average transaction value alongside the timing of price increases.\n\nThe cohort retention matrix follows monthly subscription cohorts over time. The gallery presents revenue and discounts, customer growth and cohort retention."
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
      "coverHeight": 767,
      "descriptionDetails": "The report compares revenue and profit across product categories and store locations. Monthly trends and product rankings provide additional detail, while inventory views show stock levels and days of inventory (DOI).\n\nThe gallery focuses on revenue, profit and inventory levels. Open the live report to explore its category and location controls."
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
      "url": "",
      "gallery": [
        {
          "src": "assets/certificates/data.webp",
          "thumb": "assets/certificates/data-thumb.webp",
          "pdf": "assets/certificates/data.pdf",
          "alt": "Data Analytics, Data Science & Machine Learning — certificate awarded to Paweł Bugowski",
          "title": "Data Analytics, Data Science & Machine Learning",
          "width": 2000,
          "height": 1488
        }
      ]
    },
    {
      "title": "Docker Mastery: Kubernetes & Swarm",
      "organization": "Udemy",
      "period": "2025",
      "url": "",
      "gallery": [
        {
          "src": "assets/certificates/docker.webp",
          "thumb": "assets/certificates/docker-thumb.webp",
          "pdf": "assets/certificates/docker.pdf",
          "alt": "Docker Mastery: Kubernetes & Swarm — certificate awarded to Paweł Bugowski",
          "title": "Docker Mastery: Kubernetes & Swarm",
          "width": 2000,
          "height": 1488
        }
      ]
    },
    {
      "title": "AWS Certified Cloud Practitioner (CCP)",
      "organization": "AWS",
      "period": "2025",
      "url": "",
      "gallery": [
        {
          "src": "assets/certificates/aws.webp",
          "thumb": "assets/certificates/aws-thumb.webp",
          "pdf": "assets/certificates/aws.pdf",
          "alt": "AWS Certified Cloud Practitioner (CCP) — certificate awarded to Paweł Bugowski",
          "title": "AWS Certified Cloud Practitioner (CCP)",
          "width": 2000,
          "height": 1546
        }
      ]
    },
    {
      "title": "JavaScript Specialist: React & Redux",
      "organization": "CodersLab",
      "period": "2024",
      "url": "",
      "gallery": [
        {
          "src": "assets/certificates/js.webp",
          "thumb": "assets/certificates/js-thumb.webp",
          "pdf": "assets/certificates/js.pdf",
          "alt": "JavaScript Specialist: React & Redux — certificate awarded to Paweł Bugowski",
          "title": "JavaScript Specialist: React & Redux",
          "width": 1414,
          "height": 2000
        }
      ]
    },
    {
      "title": "Scrum Developer Certified (SDC)",
      "organization": "SCRUMstudy",
      "period": "2024",
      "url": "",
      "gallery": [
        {
          "src": "assets/certificates/scrum.webp",
          "thumb": "assets/certificates/scrum-thumb.webp",
          "pdf": "assets/certificates/scrum.pdf",
          "alt": "Scrum Developer Certified (SDC) — certificate awarded to Paweł Bugowski",
          "title": "Scrum Developer Certified (SDC)",
          "width": 2000,
          "height": 1546
        }
      ]
    },
    {
      "title": "Python Developer",
      "organization": "CodersLab",
      "period": "2024",
      "url": "",
      "gallery": [
        {
          "src": "assets/certificates/python.webp",
          "thumb": "assets/certificates/python-thumb.webp",
          "pdf": "assets/certificates/python.pdf",
          "alt": "Python Developer — certificate awarded to Paweł Bugowski",
          "title": "Python Developer",
          "width": 1414,
          "height": 2000
        }
      ]
    }
  ]
};
