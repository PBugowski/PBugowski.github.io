# GitHub Pages deployment

Upload the contents of this folder to the root of `PBugowski/PBugowski.github.io`, on the `main` branch. Keep `index.html`, `Assets/`, `Demo_projects/` and `.nojekyll` at the repository root; do not upload the enclosing ZIP folder as another nested directory.

The site uses the exact directory names from the supplied repository. GitHub Pages paths are case-sensitive: use `Assets`, not `assets`. Project graphics are loaded from each project's `Assets/` directory inside `Demo_projects/`. Folder names containing spaces are supported.

`Assets/js/content.js` contains the image paths and project links. View SQL opens each project's SQL folder on GitHub, where visitors can browse all scripts. These links target the repository's `main` branch; update `codeUrl` if the repository or branch changes. The two NYC video buttons use the Vimeo URLs already provided in that project's README.

The original SQL scripts, CSV data, project READMEs, images and certificates have been preserved. The author photo is included at `Assets/images/autor.png`. The existing two-row featured action layout, galleries, certificate viewer and Read more behavior are preserved.

If GitHub Pages is configured to deploy from a branch, select `main` and `/ (root)`. After deployment, refresh the browser cache if the previous stylesheet or content is still displayed.

Validation: all referenced local HTML, CSS and content-data assets were checked with case-sensitive paths; JavaScript syntax and archive integrity were checked. External GitHub, Vimeo and Power BI destinations were mapped from the supplied files and were not tested online. Browser visual verification was unavailable.
