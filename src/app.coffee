sun = require('./sun')(44.154, 1.758) # set for Saint-Antonin-Noble-Val
robot = require("@superpingu/walkinglib")()

targetZenith = targetAzimut = 0

zenith = robot.ax12(129)
azimut = robot.ax12(164)
zenith.speed(50)
azimut.speed(50)

# hardware control
wpi = require 'wiring-pi'
wpi.setup 'wpi'
wpi.pinMode 5, wpi.INPUT # hall sensor input
wpi.pullUpDnControl 5, wpi.PUD_UP

wpi.wiringPiISR 5, wpi.INT_EDGE_FALLING, ->
    zenith.torque(0)
    azimut.torque(0)
wpi.wiringPiISR 5, wpi.INT_EDGE_RISING, ->
    position = sun()
    zenith.torque(50)
    azimut.torque(50)
    targetZenith = 2*zenith.position() - sun().zenith
    targetAzimut = -2*azimut.position() - sun().azimut

t = ->
    position = sun()
    console.log position
    zenith.moveTo 0.5*(position.zenith + targetZenith)
    azimut.moveTo -0.5*(position.azimut + targetAzimut)

setInterval t, 1000
