UTCtime = ->
    tmLoc = new Date()
    # convert to hours
    return (tmLoc.getTime()/60000)/60 % 24

#returns current day of the year (from 1 to 366)
getDay = ->
    now = new Date()
    diff = now - new Date(now.getFullYear(), 0, 0)
    return Math.floor diff/(1000*60*60*24)

#returns current time in hour (from 0 to 24)
sunTime = (longitude) ->
    t = 2*Math.PI*(getDay() - 81)/365
    E = 7.53*Math.cos(t) + 1.5*Math.sin(t) - 9.87*Math.sin(2*t)
    DTg = longitude*4  # correction de l'erreur géographique
    return UTCtime() + (DTg - E)/60

module.exports = (latitude, longitude) ->
    lat = latitude*2*Math.PI/360
    return ->
        Ah = 2*Math.PI*(sunTime(longitude) - 12)/24 # hour angle
        dec = 2*Math.PI*23.45*Math.sin(2*Math.PI*(getDay()+284)/365)/360 #current declinaison

        zenith = Math.asin(Math.sin(lat)*Math.sin(dec) + Math.cos(lat)*Math.cos(dec)*Math.cos(Ah))
        azimut = Math.asin(Math.cos(dec)*Math.sin(Ah)/Math.cos(zenith))

        # during a day, azimut should increase, azimut2 should be greater than azimut
        Ah += 0.001
        zenith2 = Math.asin(Math.sin(lat)*Math.sin(dec) + Math.cos(lat)*Math.cos(dec)*Math.cos(Ah))
        azimut2 = Math.asin(Math.cos(dec)*Math.sin(Ah)/Math.cos(zenith))

        # correct asin error if azimut is not increasing
        azimut = Math.PI - azimut if azimut2 < azimut

        return zenith: zenith*180/Math.PI, azimut: azimut*180/Math.PI
