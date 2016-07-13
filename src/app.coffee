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
wpi.pinMode 5, wpi.INPUT
wpi.pullUpDnControl 5, wpi.PUD_UP

onPush = ->
    axis.torque(0)
    zenith.update()
    azimut.update()
    console.log 'push'

onPull = ->
    position = sun()
    axis.torque(50)
    zenith.update()
    azimut.update()
    
    targetZenith = 2*zenith.position() - sun().zenith
    targetAzimut = -2*azimut.position() - sun().azimut
    console.log 'pull'

oldValue = 1
t = ->
    if wpi.digitalRead 5
        onPull() if oldValue != wpi.digitalRead 5

        position = sun()
        console.log position
        zenith.moveTo 0.5*(position.zenith + targetZenith)
        azimut.moveTo -0.5*(position.azimut + targetAzimut)
    else 
        onPush() if oldValue != wpi.digitalRead 5
    oldValue = wpi.digitalRead 5
    console.log wpi.digitalRead 5

setInterval t, 1000
