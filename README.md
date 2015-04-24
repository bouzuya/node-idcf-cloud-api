# node-idcf-cloud-api

A library for [IDCF cloud API](http://www.idcf.jp/cloud/docs/) written in JavaScript.

## Installation

```bash
$ npm install idcf-cloud-api
```

## Usage

```javascript
var idcf = require('idcf-cloud-api');

var client = idcf({
  endpoint: 'https://compute.jp-east.idcfcloud.com/client/api',
  apiKey: 'XXX',
  secretKey: 'YYY'
});
client.request('listZones', {})
.then(function(result) {
  console.log(result);
});
```

## Development

See `npm run`

## License

[MIT](LICENSE)

## Author

[bouzuya][user] &lt;[m@bouzuya.net][email]&gt; ([http://bouzuya.net][url])

## Badges

[![Build Status][travis-badge]][travis]
[![Dependencies status][david-dm-badge]][david-dm]

[travis]: https://travis-ci.org/bouzuya/node-idcf-cloud-api
[travis-badge]: https://travis-ci.org/bouzuya/node-idcf-cloud-api.svg?branch=master
[david-dm]: https://david-dm.org/bouzuya/node-idcf-cloud-api
[david-dm-badge]: https://david-dm.org/bouzuya/node-idcf-cloud-api.png
[user]: https://github.com/bouzuya
[email]: mailto:m@bouzuya.net
[url]: http://bouzuya.net
