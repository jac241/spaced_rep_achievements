process.env.NODE_ENV = process.env.NODE_ENV || 'production'
process.env.WEBPACKER_ASSET_HOST = 'https://ankiachievements.com'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
