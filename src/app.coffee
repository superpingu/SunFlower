sun = require('./sun')(44.154, 1.758)

t = -> console.log(sun())

setInterval t, 1000
