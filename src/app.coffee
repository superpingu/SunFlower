sun = require('./sun')(44.154, 1.758) # set for Saint-Antonin-Noble-Val
robot = require("@superpingu/walkinglib")()

targetZenith = targetAzimut = 0

axis = robot.ax12(0)
zenith = axis.create(129)
azimut = axis.create(164)
axis.speed(100)
axis.update()

# hardware control
wpi = require 'wiring-pi'
wpi.setup 'wpi'
wpi.pinMode 5, wpi.INPUT # hall sensor input
wpi.pullUpDnControl 5, wpi.PUD_UP

onPush = ->
    axis.torque(0)
    axis.update()
    console.log 'push'

onPull = ->
    position = sun()
    axis.torque(50)
    axis.update()
    targetZenith = 2*zenith.position() - sun().zenith
    targetAzimut = -2*azimut.position() - sun().azimut
    console.log 'pull'

ignore = no
wpi.wiringPiISR 5, wpi.INT_EDGE_BOTH, ->
    return if ignore
    onPush if not wpi.digitalRead 5
    onPull if wpi.digitalRead 5
    ignore = yes
    setTimeout((-> ignore = no), 100)

t = ->
    return if ignore or not wpi.digitalRead 5
    position = sun()
    console.log position
    zenith.moveTo 0.5*(position.zenith + targetZenith)
    azimut.moveTo -0.5*(position.azimut + targetAzimut)

setInterval t, 1000
