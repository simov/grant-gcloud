
var grant = require('grant').gcloud({
  config: require('./config.json'), session: {secret: 'grant'}
})

exports.handler = async (req, res) => {
  await grant(req, res)
}
