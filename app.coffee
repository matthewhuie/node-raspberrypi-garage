express = require 'express'
rpio = require 'rpio'
app = express()

PIN_GARAGE_BUTTON = 7

app.get '/toggle', (req, res) ->
  try
    rpio.open PIN_GARAGE_BUTTON, rpio.OUTPUT, rpio.LOW
    rpio.write PIN_GARAGE_BUTTON, rpio.HIGH
    rpio.sleep 3
    rpio.write PIN_GARAGE_BUTTON, rpio.LOW
    res.send 'Pressed'
  catch e
    res.sendStatus 500
  finally
    rpio.close PIN_GARAGE_BUTTON

app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT or 8080
