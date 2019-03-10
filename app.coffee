express = require 'express'
rpio = require 'rpio'
app = express()

PIN_GARAGE_BUTTON = 7
PIN_GARAGE_LED = 0
PIN_ULTRASONIC_TRIGGER = 15
PIN_ULTRASONIC_ECHO = 16
SPEED_SOUND_MM_MS = 343

getDistance = () ->
  try
    rpio.open PIN_ULTRASONIC_TRIGGER, rpio.OUTPUT, rpio.LOW
    rpio.open PIN_ULTRASONIC_ECHO, rpio.INPUT, rpio.LOW
    
    rpio.write PIN_ULTRASONIC_TRIGGER, rpio.HIGH
    rpio.msleep 0.01
    rpio.write PIN_ULTRASONIC_TRIGGER, rpio.LOW

    start = new Date().getTime() while rpio.read(PIN_ULTRASONIC_ECHO) == rpio.LOW
    end = new Date().getTime() while rpio.read(PIN_ULTRASONIC_ECHO) == rpio.HIGH

    console.log (end - start) * SPEED_SOUND_MM_MS / 2
  catch e
    res.sendStatus 500
  finally
    rpio.close PIN_ULTRASONIC_TRIGGER
    rpio.close PIN_ULTRASONIC_ECHO

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
