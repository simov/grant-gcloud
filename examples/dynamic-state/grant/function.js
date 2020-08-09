
var grant = require('grant').gcloud({
  config: require('./config.json'),
  session: {secret: 'grant', store: require('./store')}
})

exports.handler = async (req, res) => {
  if (/\/connect\/google$/.test(req.url)) {
    var state = {dynamic: {scope: ['openid']}}
  }
  else if (/\/connect\/twitter$/.test(req.url)) {
    var state = {dynamic: {key: 'CONSUMER_KEY', secret: 'CONSUMER_SECRET'}}
  }

  var {response, session} = await grant(req, res, state)
  if (response) {
    await session.remove()
    res.statusCode = 200
    res.setHeader('content-type', 'text/plain')
    res.end(JSON.stringify(response, null, 2))
  }
}
