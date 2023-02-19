angular.module("map").directive "location", ->
  (scope, element, attr) ->

    leaflet = L.map('leaflet', {zoomControl: false, dragging: false, touchZoom: false, scrollWheelZoom: false,boxZoom: false}).setView([51.505, -0.09], 13)
    L.tileLayer('http://c.tiles.mapbox.com/v3/superhighfives.map-tveg0pv0/{z}/{x}/{y}.png').addTo(leaflet)

    scope.$watch 'currentMarker', (marker) ->
      if(marker)
        leaflet.panTo([marker.latitude, marker.longitude])
