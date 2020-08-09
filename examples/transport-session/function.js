
exports.function = async (req, res) => {
  /^\/connect/.test(req.url)
   ? require('./grant/function').handler(req, res)
   : require('./callback/function').handler(req, res)
}
