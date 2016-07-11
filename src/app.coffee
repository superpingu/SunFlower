sun = require('./sun')(44.154, 1.758) # set for Saint-Antonin-Noble-Val
robot = require "walkinglib"

zenith = robot.ax12(129)
azimut = robot.ax12(164)

zenith.speed(30)
azimut.speed(30)

t = ->
    position = sun()
    console.log(position)
    zenith.move(position.zenith)
    azimut.move(position.azimut)

setInterval t, 1000

zenith = robot.ax12(129)
azimut = robot.ax12(164)
