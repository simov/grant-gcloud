
var grant = require('grant').gcloud({
  config: require('./config.json'), session: {name: '__session', secret: 'grant'}
})

exports.handler = async (req, res) => {
  var {response} = await grant(req, res)
  if (response) {
    res.statusCode = 200
    res.setHeader('content-type', 'text/plain')
    res.end(JSON.stringify(response, null, 2))
  }
}
