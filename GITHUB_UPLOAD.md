# Upload this project to GitHub

Use `uvm_memory/` as the repository root. Source code and Markdown files belong in the repository; `build/`, `.deps/` and raw logs are excluded by `.gitignore`. The EDA Playground sources in `eda_playground/` are included.

Create an empty repository on GitHub. From this project directory:

```bash
git init -b main
git add .
git status --short
git diff --cached --stat
git commit -m "Add UVM memory verification project"
# Replace YOUR_USERNAME and YOUR_REPOSITORY with your actual repository.
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Review the staged files before committing. This guide assumes a new empty remote; use the normal existing-repository workflow if the destination already contains commits. The project preparation does not create or push a GitHub repository.
