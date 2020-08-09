
# grant-gcloud

> _Google Cloud Function handler for **[Grant]**_

```js
var grant = require('grant').gcloud({
  config: {/*configuration - see below*/}, session: {secret: 'grant'}
})

exports.handler = async (req, res) => {
  var {response} = await grant(req, res)
  if (response) {
    res.statusCode = 200
    res.setHeader('content-type', 'application/json')
    res.end(JSON.stringify(response))
  }
}
```

> _Also available for [AWS], [Azure], [Vercel]_

---

## Configuration

The `config` key expects your [**Grant** configuration][grant-config].

#### Lambda Prefix

You have to specify the absolute path `prefix` that includes your lambda name:

```json
{
  "defaults": {
    "origin": "https://[REGION]-[PROJECT].cloudfunctions.net",
    "prefix": "/[lambda]/connect"
  },
  "google": {}
}
```

---

## Routes

You login by navigating to:

```
https://[REGION]-[PROJECT].cloudfunctions.net/[LAMBDA]/connect/google
```

The redirect URL of your OAuth app have to be set to:

```
https://[REGION]-[PROJECT].cloudfunctions.net/[LAMBDA]/connect/google/callback
```

And locally:

```
http://localhost:3000/connect/google
http://localhost:3000/connect/google/callback
```

---

## Session

The `session` key expects your session configuration:

Option | Description
:- | :-
`name` | Cookie name, defaults to `grant`
`secret` | Cookie secret, **required**
`cookie` | [cookie] options, defaults to `{path: '/', httpOnly: true, secure: false, maxAge: null}`
`store` | External session store implementation

#### NOTE:

- The default cookie store is used unless you specify a `store` implementation!
- Using the default cookie store **may leak private data**!
- Implementing an external session store is recommended for production deployments!

Example session store implementation using [Firebase]:

```js
var request = require('request-compose').client

var path = process.env.FIREBASE_PATH
var auth = process.env.FIREBASE_AUTH

module.exports = {
  get: async (sid) => {
    var {body} = await request({
      method: 'GET', url: `${path}/${sid}.json`, qs: {auth},
    })
    return body
  },
  set: async (sid, json) => {
    await request({
      method: 'PATCH', url: `${path}/${sid}.json`, qs: {auth}, json,
    })
  },
  remove: async (sid) => {
    await request({
      method: 'DELETE', url: `${path}/${sid}.json`, qs: {auth},
    })
  },
}
```

---

## Handler

The Google Cloud Funtion handler for Grant accepts:

Argument | Type | Description
:- | :- | :-
`req` | **required** | The request object
`res` | **required** | The response object
`state` | optional | [Dynamic State][grant-dynamic-state] object `{dynamic: {..Grant configuration..}}`

The Google Cloud Funtion handler for Grant returns:

Parameter | Availability | Description
:- | :- | :-
`session` | Always | The session store instance, `get`, `set` and `remove` methods can be used to manage the Grant session
`redirect` | On redirect only | HTTP redirect controlled by Grant, it is set to `true` when Grant is going to handle the redirect internally
`response` | Based on transport | The [response data][grant-response-data], available for [transport-state][example-transport-state] and [transport-session][example-transport-session] only

---

## Examples

Example | Session | Callback λ
:- | :- | :-
`transport-state` | Cookie Store | ✕
`transport-querystring` | Cookie Store | ✓
`transport-session` | Firebase Session Store | ✓
`dynamic-state` | Firebase Session Store | ✕

> _Different session store types were used for example purposes only._

#### Configuration

All variables at the top of the [`Makefile`][example-makefile] with value set to `...` have to be configured:

- `project` - Project ID
- `account.json` - Project Service Account Credentials

- `firebase_path` - [Firebase] path of your database, required for [transport-session][example-transport-session] and [dynamic-state][example-dynamic-state] examples

```
https://[project].firebaseio.com/[prefix]
```

- `firebase_auth` - [Firebase] auth key of your database, required for [transport-session][example-transport-session] and [dynamic-state][example-dynamic-state] examples

```json
{
  "rules": {
    ".read": "auth == '[key]'",
    ".write": "auth == '[key]'"
  }
}
```

All variables can be passed as arguments to `make` as well:

```bash
make plan example=transport-querystring ...
```

---

## Develop

```bash
# build example locally
make build-dev
# run example locally
make run-dev
```

---

## Deploy

```bash
# build Grant lambda for deployment
make build-grant
# build callback lambda for transport-querystring and transport-session examples
make build-callback
# execute only once
make init
# plan before every deployment
make plan
# apply plan for deployment
make apply
# cleanup resources
make destroy
```

---

  [Grant]: https://github.com/simov/grant
  [AWS]: https://github.com/simov/grant-aws
  [Azure]: https://github.com/simov/grant-azure
  [Google Cloud]: https://github.com/simov/grant-gcloud
  [Vercel]: https://github.com/simov/grant-vercel

  [cookie]: https://www.npmjs.com/package/cookie
  [Firebase]: https://firebase.google.com/

  [grant-config]: https://github.com/simov/grant#configuration
  [grant-dynamic-state]: https://github.com/simov/grant#dynamic-state
  [grant-response-data]: https://github.com/simov/grant#callback-data

  [example-makefile]: https://github.com/simov/grant-gcloud/tree/master/Makefile
  [example-transport-state]: https://github.com/simov/grant-gcloud/tree/master/examples/transport-state
  [example-transport-querystring]: https://github.com/simov/grant-gcloud/tree/master/examples/transport-querystring
  [example-transport-session]: https://github.com/simov/grant-gcloud/tree/master/examples/transport-session
  [example-dynamic-state]: https://github.com/simov/grant-gcloud/tree/master/examples/dynamic-state
