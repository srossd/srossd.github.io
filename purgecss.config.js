const fs = require("fs");

// The Jupyter/Mathematica theme stylesheets contain selectors that
// PurgeCSS's parser rejects, so they are copied through untouched.
const cssDir = "_site/assets/css/";
const css = fs
  .readdirSync(cssDir)
  .filter((f) => f.endsWith(".css") && !f.startsWith("jupyter_mma"))
  .map((f) => cssDir + f);

module.exports = {
  content: ["_site/**/*.html", "_site/**/*.js"],
  css,
  output: "_site/assets/css/",
  skippedContentGlobs: ["_site/assets/**/*.html"],
};
