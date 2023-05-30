const express = require('express');
const app = express();
const path = require('path');
const environment = process.env.DEPLOY_ENVIRONMENT || 'development';

// Determine the configuration file based on the environment
const configFileName = `config-${environment}.js`;
const config = require(path.join(__dirname, 'config', configFileName));

app.get('/', (req, res) => {
  res.send(config.text);
});

app.listen(config.port, () => {
  console.log(`Listening on port ${config.port}`);
});

module.exports = app;
