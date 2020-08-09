
exports.handler = async (req, res) => {
  res.statusCode = 200
  res.setHeader('content-type', 'text/plain')
  res.end(JSON.stringify(req.query, null, 2))
}
