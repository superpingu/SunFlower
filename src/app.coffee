sun = require('./sun')(44.154, 1.758) # set for Saint-Antonin-Noble-Val
robot = require("@superpingu/walkinglib")()

zenith = robot.ax12(129)
azimut = robot.ax12(164)

zenith.speed(50)
azimut.speed(50)

t = ->
    position = sun()
    console.log(position)
    zenith.moveTo(position.zenith)
    azimut.moveTo(-position.azimut)

setInterval t, 1000
