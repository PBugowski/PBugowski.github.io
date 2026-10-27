/* Edit your profile, project links and qualifications here.
 * Empty SQL/video links show disabled Coming soon buttons.
 * Add your portrait under Assets/images/ and update photo and photoAlt.
 * Add your CV PDF and update cv to show the download link.
 * Add a description of your responsibilities to experience[].description.
 * Demo flags preserve the existing portfolio labels.
 */
window.PORTFOLIO = {
  "name": "Paweł Bugowski",
  "role": "Data Analyst",
  "about": "I’m Paweł, a process engineer looking to bring my analytical skills into a Data Analyst role. My background shapes how I approach problems: understand the process, examine the details and check whether the conclusions hold up.\n\nI’ve completed nine projects covering topics such as retail sales, video games, UK railway performance, company rankings and road safety. The three projects featured here are a selection of that work. Across these projects, I’ve developed my skills in preparing data, writing SQL, validating results and building interactive Power BI reports.\n\nI enjoy investigating how things work and finding patterns that deserve a closer look. I also care about making my work easy to follow through clear visuals, documented calculations and explanations of what the data can — and cannot — tell us.\n\nI’m looking for a team where I can contribute, learn from experienced colleagues and apply these skills to real business challenges. If you’re hiring a Data Analyst, I’d be glad to discuss how I could support your team.",
  "photo": "Assets/images/autor.png",
  "photoAlt": "Paweł Bugowski — Data Analyst",
  "email": "pbugowski96@gmail.com",
  "linkedin": "https://www.linkedin.com/in/pawelbugowski/",
  "github": "https://github.com/PBugowski",
  "cv": "Assets/documents/Pawel_Bugowski_CV.pdf",
  "skills": [
    {
      "name": "SQL",
      "icon": "sql",
      "group": "tools",
      "items": [
        "Joins & subqueries",
        "CTEs & recursive queries",
        "Window functions",
        "SQL views & reporting layers"
      ]
    },
    {
      "name": "Power BI",
      "icon": "power-bi",
      "group": "tools",
      "items": [
        "Interactive dashboards & reports",
        "Data modeling & relationships",
        "Filters, slicers & cross-filtering",
        "Report navigation & drill-through"
      ]
    },
    {
      "name": "Excel",
      "icon": "excel",
      "group": "tools",
      "items": [
        "Advanced formulas & calculations",
        "PivotTables & PivotCharts",
        "Lookup & reference functions",
        "Conditional aggregations"
      ]
    },
    {
      "name": "Data Preparation",
      "icon": "prepare",
      "group": "workflow",
      "items": [
        "Data type & format standardization",
        "Missing-value handling",
        "Granularity alignment across datasets",
        "Reusable data preparation workflows"
      ]
    },
    {
      "name": "Data Quality & Validation",
      "icon": "validate",
      "group": "workflow",
      "items": [
        "Data profiling & anomaly detection",
        "Referential integrity checks",
        "Join cardinality & duplication checks",
        "Aggregation & KPI validation"
      ]
    },
    {
      "name": "Data Analysis",
      "icon": "analyze",
      "group": "workflow",
      "items": [
        "Trend & period-over-period analysis",
        "Cohort & retention analysis",
        "Customer segmentation & behavior analysis",
        "Spatial & geographic analysis"
      ]
    },
    {
      "name": "Data Visualization & Communication",
      "icon": "communicate",
      "group": "workflow",
      "items": [
        "Information hierarchy & dashboard composition",
        "Interactive exploration & drill-through",
        "Data storytelling & analytical narratives",
        "Report presentations & walkthroughs"
      ]
    },
    {
      "name": "Project Documentation",
      "icon": "document",
      "group": "workflow",
      "items": [
        "Data dictionaries & metric definitions",
        "Data model & relationship documentation",
        "Assumptions, limitations & methodology",
        "Validation procedures & reconciliation notes"
      ]
    }
  ],
  "projects": [
    {
      "title": "NYC Accidents 2020",
      "demo": true,
      "description": "Where do New York City collisions concentrate, and how do their consequences differ? I explored 74,881 reported collisions from January 1 to August 29, 2020, combining MySQL, spatial analysis and Power BI.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiOWIzYWE4NGYtZmI1OS00MWU1LThmYzktZDI4M2UwYmE3YmI0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "https://github.com/PBugowski/PBugowski.github.io/tree/main/Demo_projects/New%20York%20City%20Traffic%20Collisions%20in%202020/SQL",
      "cover": "Demo_projects/New York City Traffic Collisions in 2020/Assets/cover.webp",
      "coverAlt": "NYC Accidents: Executive Overview",
      "gallery": [
        {
          "src": "Demo_projects/New York City Traffic Collisions in 2020/Assets/gallery-01.webp",
          "thumb": "Demo_projects/New York City Traffic Collisions in 2020/Assets/gallery-01-thumb.webp",
          "alt": "NYC Accidents: Accidents over Time",
          "title": "Accidents over Time"
        },
        {
          "src": "Demo_projects/New York City Traffic Collisions in 2020/Assets/gallery-02.webp",
          "thumb": "Demo_projects/New York City Traffic Collisions in 2020/Assets/gallery-02-thumb.webp",
          "alt": "NYC Accidents: Accident Locations",
          "title": "Accident Locations"
        },
        {
          "src": "Demo_projects/New York City Traffic Collisions in 2020/Assets/gallery-03.webp",
          "thumb": "Demo_projects/New York City Traffic Collisions in 2020/Assets/gallery-03-thumb.webp",
          "alt": "NYC Accidents: Accidents with Injuries",
          "title": "Accidents with Injuries"
        }
      ],
      "reportVideoUrl": "https://vimeo.com/1237617344",
      "sqlVideoUrl": "https://vimeo.com/1237618906",
      "coverTitle": "Executive Overview",
      "coverWidth": 1363,
      "coverHeight": 767,
      "descriptionDetails": "Explore six report pages to compare boroughs, streets, times of day and vehicle types. Follow the sharp drop in collision counts in spring 2020, then examine how injury and fatal collision patterns differ across pedestrians, cyclists and motorists.\n\nOne finding worth exploring: pedestrians represent around 15% of recorded injuries but 39% of fatalities. Comparing collision frequency with outcomes reveals a different picture of street safety and helps identify locations and road-user groups for closer investigation.\n\nBehind the visuals, SQL standardizes inconsistent categories, uses geographic boundaries to assign missing boroughs where coordinates allow, and builds reporting and vehicle bridge views. Distinct collision counts keep repeated vehicle records from inflating the analysis.\n\nOpen the live report to investigate a borough or time period, or explore the SQL to trace the path from raw records to report-ready data. The two video walkthroughs explain the report and code in Polish."
    },
    {
      "title": "KajoDataSpace Transactions",
      "demo": true,
      "description": "What sits behind subscription revenue growth: more customers, higher payments or repeat purchases? Explore 4,227 transactions from 1,057 customers across 2023–2026, from pricing changes to customer retention.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiNGZjYmEwMDgtZGJhMS00ZGZjLWEyOWUtZDc3MmE0MmU0MzQ1IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "https://github.com/PBugowski/PBugowski.github.io/tree/main/Demo_projects/KajoDataSpace%20-%20Transactions%20and%20Customer%20Activity%20in%202023-2026/SQL",
      "cover": "Demo_projects/KajoDataSpace - Transactions and Customer Activity in 2023-2026/Assets/cover.webp",
      "coverAlt": "KajoDataSpace Transactions: Executive Overview",
      "gallery": [
        {
          "src": "Demo_projects/KajoDataSpace - Transactions and Customer Activity in 2023-2026/Assets/gallery-01.webp",
          "thumb": "Demo_projects/KajoDataSpace - Transactions and Customer Activity in 2023-2026/Assets/gallery-01-thumb.webp",
          "alt": "KajoDataSpace Transactions: Revenue and Discounts",
          "title": "Revenue and Discounts"
        },
        {
          "src": "Demo_projects/KajoDataSpace - Transactions and Customer Activity in 2023-2026/Assets/gallery-02.webp",
          "thumb": "Demo_projects/KajoDataSpace - Transactions and Customer Activity in 2023-2026/Assets/gallery-02-thumb.webp",
          "alt": "KajoDataSpace Transactions: Customer Growth",
          "title": "Customer Growth"
        },
        {
          "src": "Demo_projects/KajoDataSpace - Transactions and Customer Activity in 2023-2026/Assets/gallery-03.webp",
          "thumb": "Demo_projects/KajoDataSpace - Transactions and Customer Activity in 2023-2026/Assets/gallery-03-thumb.webp",
          "alt": "KajoDataSpace Transactions: Customer Cohort Retention",
          "title": "Customer Cohort Retention"
        }
      ],
      "coverTitle": "Executive Overview",
      "coverWidth": 1280,
      "coverHeight": 720,
      "descriptionDetails": "The report connects revenue trends with subscription plans, new-customer activity and monthly cohort retention. Compare the periods around price increases and explore how purchase frequency and payment values change over time.\n\nBehind the dashboards, SQL prepares transaction data, distinguishes first and subsequent purchases, summarizes customer histories and supplies activity records for retention analysis. Open the report to explore the patterns, then follow the SQL to see how the underlying measures are built."
    },
    {
      "title": "Maven Toys — Sales & Inventory",
      "demo": true,
      "description": "Do the best-selling toys also generate the most profit? Explore 829,262 sales records across 50 Mexican stores to compare product demand, financial contribution and inventory.",
      "tools": [
        "SQL",
        "Power BI"
      ],
      "url": "https://app.powerbi.com/view?r=eyJrIjoiNjZmM2I0Y2QtNmYzMC00ODE4LWJiOTQtZDQzODA5MmIzN2Q0IiwidCI6ImE0ZmE1ZWNhLTdhM2YtNDRhYS04ZTI4LTc2MjBhMzk0NjEwZiJ9",
      "codeUrl": "https://github.com/PBugowski/PBugowski.github.io/tree/main/Demo_projects/Maven%20Toys%20-%20Sales%20and%20Inventory%20in%20Mexican%20Toy%20Stores/SQL",
      "cover": "Demo_projects/Maven Toys - Sales and Inventory in Mexican Toy Stores/Assets/cover.webp",
      "coverAlt": "Maven Toys: Sales and Inventory Overview",
      "gallery": [
        {
          "src": "Demo_projects/Maven Toys - Sales and Inventory in Mexican Toy Stores/Assets/gallery-01.webp",
          "thumb": "Demo_projects/Maven Toys - Sales and Inventory in Mexican Toy Stores/Assets/gallery-01-thumb.webp",
          "alt": "Maven Toys: Revenue Analysis",
          "title": "Revenue Analysis"
        },
        {
          "src": "Demo_projects/Maven Toys - Sales and Inventory in Mexican Toy Stores/Assets/gallery-02.webp",
          "thumb": "Demo_projects/Maven Toys - Sales and Inventory in Mexican Toy Stores/Assets/gallery-02-thumb.webp",
          "alt": "Maven Toys: Profit Analysis",
          "title": "Profit Analysis"
        },
        {
          "src": "Demo_projects/Maven Toys - Sales and Inventory in Mexican Toy Stores/Assets/gallery-03.webp",
          "thumb": "Demo_projects/Maven Toys - Sales and Inventory in Mexican Toy Stores/Assets/gallery-03-thumb.webp",
          "alt": "Maven Toys: Inventory Levels",
          "title": "Inventory Levels"
        }
      ],
      "coverTitle": "Sales and Inventory Overview",
      "coverWidth": 1352,
      "coverHeight": 767,
      "descriptionDetails": "Art & Crafts leads in units sold, while Toys leads in revenue and profit. Electronics has the lowest category sales volume but the second-highest profit. Explore these differences through category and location filters, then compare stock levels and inventory value.\n\nThe SQL joins sales, products, stores and inventory, builds reporting views, and validates key totals. Its stock-coverage calculations provide a starting point for investigating availability. Open the live report to compare the business perspectives, or inspect the SQL to follow the calculations back to the source data."
    }
  ],
  "experience": [
    {
      "title": "Process Engineer",
      "organization": "PRODMAX SP. Z O.O.",
      "period": "November 2020 – Present",
      "description": "I combine process analysis, production coordination and data quality oversight to support operational decisions and improve how work is planned, executed and recorded.",
      "responsibilities": [
        "Analyze production workflows to identify bottlenecks, investigate inefficiencies and develop practical process improvements.",
        "Validate production data recorded in the ERP system, investigate inconsistencies and support accurate, reliable information for operational use.",
        "Prepare cost estimates and build pricing calculators, translating production requirements into structured, repeatable calculations.",
        "Create and monitor production orders, assess execution progress and coordinate responses to constraints affecting order completion.",
        "Serve as the first point of contact for production issues, investigating problems and working across departments to identify causes and implement solutions.",
        "Develop technological processes and supporting documentation, making production requirements, operating procedures and responsibilities clear and consistent."
      ],
      "achievements": [
        "Designed and launched a new distribution department, establishing its operating processes, developing procedures and training materials, and training employees.",
        "Led technological modernization initiatives in two production departments, improving the accuracy and consistency of production data recorded in internal systems."
      ]
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
          "src": "Assets/certificates/data.webp",
          "thumb": "Assets/certificates/data-thumb.webp",
          "pdf": "Assets/certificates/data.pdf",
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
          "src": "Assets/certificates/docker.webp",
          "thumb": "Assets/certificates/docker-thumb.webp",
          "pdf": "Assets/certificates/docker.pdf",
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
          "src": "Assets/certificates/aws.webp",
          "thumb": "Assets/certificates/aws-thumb.webp",
          "pdf": "Assets/certificates/aws.pdf",
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
          "src": "Assets/certificates/js.webp",
          "thumb": "Assets/certificates/js-thumb.webp",
          "pdf": "Assets/certificates/js.pdf",
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
          "src": "Assets/certificates/scrum.webp",
          "thumb": "Assets/certificates/scrum-thumb.webp",
          "pdf": "Assets/certificates/scrum.pdf",
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
          "src": "Assets/certificates/python.webp",
          "thumb": "Assets/certificates/python-thumb.webp",
          "pdf": "Assets/certificates/python.pdf",
          "alt": "Python Developer — certificate awarded to Paweł Bugowski",
          "title": "Python Developer",
          "width": 1414,
          "height": 2000
        }
      ]
    }
  ],
  "aboutTitle": "From process engineering to data analysis"
};
