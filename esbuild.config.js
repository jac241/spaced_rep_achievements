const { sassPlugin } = require("esbuild-sass-plugin")
const rails = require("esbuild-rails")
const svgrPlugin = require("esbuild-plugin-svgr")
const path = require("path")

require("esbuild")
  .build({
    entryPoints: ["app/javascript/application.js", "app/javascript/anki.js"],
    bundle: true,
    loader: {
      ".js": "jsx",
      ".png": "dataurl",
    },
    outdir: path.join(process.cwd(), "app/assets/builds"),
    watch: process.argv.includes("--watch"),
    plugins: [sassPlugin(), rails(), svgrPlugin()],
    define: {
      "process.env.ASSET_HOST": JSON.stringify(process.env["ASSET_HOST"]),
      "process.env.CABLE_URL": JSON.stringify(process.env["CABLE_URL"]),
    },
    target: "es6",
  })
  .catch(() => process.exit(1))
// "esbuild app/javascript/*.* --bundle --loader:.js=jsx --loader:.scss=css --sourcemap --outdir=app/assets/builds"
