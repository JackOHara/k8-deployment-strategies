const express = require('express');

const app = express();
const port = process.env.PORT || 3000;

const responseTracker = {};

function responseTrack(statusCode){
  if(statusCode in responseTracker) {
    responseTracker[statusCode] += 1;
  } else {
    responseTracker[statusCode] = 1;
  }
}

app.use((req, res, next) => {
  const oldSend = res.send
  res.send = function(data) {
    responseTrack(res.statusCode)
      res.send = oldSend
      return res.send(data)
  }
  next()
})

app.get('/demo/cop', (req, res) => {
  res.send({
    message: 'Demo time.',
  });
});

app.get('/demo/alive', (req, res) => {
  res.send({
    message: 'We are alive!',
  });
});

app.get('/demo/ready', (req, res) => {
  res.send({
    message: 'We are ready to rock!!',
  });
});

app.get('/demo/version', (req, res) => {
  res.send({
    message: `Version is ${process.env.VERSION}`,
  });
});

app.get('/demo/error', (req, res) => {
  res.sendStatus(500);
});

app.get('/demo/metrics', (req, res) => {
  res.send({metrics: responseTracker});
});

app.listen(port, () => console.log(`listening on port ${port}!`));
