process.env.NODE_ENV = process.env.NODE_ENV || "development"
process.env.WEBPACKER_ASSET_HOST = "http://localhost:3000"

const environment = require("./environment")

module.exports = environment.toWebpackConfig()
