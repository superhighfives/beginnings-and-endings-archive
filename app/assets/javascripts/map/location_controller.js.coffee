angular.module("map").controller "Location", [
  '$scope'
  ($scope) ->

    leaflet = L.map('leaflet', {zoomControl: false, dragging: false, touchZoom: false, scrollWheelZoom: false,boxZoom: false}).setView([51.505, -0.09], 13)
    L.tileLayer('http://c.tiles.mapbox.com/v3/superhighfives.map-tveg0pv0/{z}/{x}/{y}.png').addTo(leaflet)

    geocoder = new google.maps.Geocoder()

    $('#marker_location').autocomplete
        source: (request, response) ->
          geocoder.geocode 'address': request.term, (results, status) ->
            response $.map results, (item) ->
              label:  item.formatted_address,
              value: item.formatted_address,
              latitude: item.geometry.location.lat(),
              longitude: item.geometry.location.lng()
        select: (event, ui) ->
          $scope.location =
            name: ui.item.formatted_address
            latitude: ui.item.latitude
            longitude: ui.item.longitude
          $scope.$apply()

    $('#marker_location').focus (e) ->
      e.preventDefault()
      $scope.location = undefined
      $scope.$apply()

    $('#marker_location').blur (e) ->
      e.preventDefault()
      $(this).autocomplete("destroy")
      geocoder.geocode 'address': @value, (results, status) ->
        if(status == "OK")
          $scope.location =
            name: results[0].formatted_address
            latitude: results[0].geometry.location.lat()
            longitude: results[0].geometry.location.lng()
          $scope.$apply()

    $scope.$watch 'location', (location) ->
      if(location)
        leaflet.panTo([location.latitude, location.longitude])
]
