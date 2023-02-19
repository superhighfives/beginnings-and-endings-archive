angular.module('map').factory 'MapUtilities', ->

  class MapUtilities

      @getDistanceBetweenLatLons = (latlngs) ->
        R = 6371; # Radius of the earth in km
        dLat = @toRad(latlngs[1].latitude - latlngs[0].latitude)  # Javascript functions in radians
        dLon = @toRad(latlngs[1].longitude - latlngs[0].longitude)
        a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(@toRad(latlngs[0].latitude)) * Math.cos(@toRad(latlngs[1].latitude)) *
              Math.sin(dLon/2) * Math.sin(dLon/2);
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
        d = R * c # Distance in km
        Math.round(d)

      @toRad = (degree) ->
        degree * Math.PI/ 180
