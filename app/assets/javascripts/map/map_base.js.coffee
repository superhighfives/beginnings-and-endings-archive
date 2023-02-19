angular.module("map").constant "MapBase",
  (scope, http, location, route, routeParams, mapDataEndPoint, MapUtilities) ->

    setCurrentMarker = (index, ignoreLocation) ->
      loopedIndex = if index < 0 then scope.markers.length - 1 else index % scope.markers.length
      scope.currentMarkerIndex = loopedIndex
      scope.currentMarker = scope.markers[loopedIndex]
      if(!ignoreLocation)
        location.path("/map/" + scope.currentMarker.code)

    getMarkerIndexByCode = (code) ->
      index = 0
      scope.markers.map (marker, i) -> if marker.code == code
        index = i
      return index

    compileTree = (markers) ->
      markersByCode = {}
      markersArray = []
      for marker in markers
        marker.children = []
        markersByCode[marker.code] = marker
        markersArray.push marker
      for marker in markers when !!marker.referrer_code
        markersByCode[marker.referrer_code].children.push marker

    measureDistances = (markers) ->
      scope.statistics.total_exchanges = 0
      scope.statistics.total_distance = 0
      measureChildren = (marker) ->
        for child in marker.children
          latlngs = [marker, child]
          total += MapUtilities.getDistanceBetweenLatLons(latlngs)
          if(child.children)
            measureChildren(child)
      for marker in markers

        if(marker.children.length)
          total = 0
          measureChildren(marker, total)
          marker.distance = total
          scope.statistics.total_exchanges += marker.children.length
          scope.statistics.total_distance += total
        else
          marker.distance = 0

    scope.next = -> setCurrentMarker(scope.currentMarkerIndex + 1)
    scope.previous = -> setCurrentMarker(scope.currentMarkerIndex - 1)

    scope.haveMarkers = ->
      scope.markers && !!scope.markers.length

    scope.showHoveredPoint = (point) ->
        scope.hoveredPoint =
          class: if point == scope.currentMarker then 'root' else 'child'
          marker: point
          style: {top: point.y, left: point.x}
        scope.$apply()

    scope.hideHoveredPoint = ->
      scope.hoveredPoint = undefined
      scope.$apply()

    scope.clickHoveredPoint = (point) ->
      setCurrentMarker(getMarkerIndexByCode(point.code))

    http.get(mapDataEndPoint).success (data) ->
      scope.markers = data.markers
      scope.statistics.total_users = scope.markers.length
      if(scope.markers.length)
        compileTree(scope.markers)
        measureDistances(scope.markers)
        scope.statistics.average_exchanges =
          scope.statistics.total_exchanges / scope.statistics.total_users
        if routeParams.markerId
          setCurrentMarker(getMarkerIndexByCode(routeParams.markerId), true)
        else
          setCurrentMarker(0)

    scope.$on "$routeChangeSuccess", ($currentRoute, $previousRoute) ->
      if(scope.markers && $previousRoute && $previousRoute.params.markerId != "")
        setCurrentMarker(getMarkerIndexByCode($previousRoute.params.markerId), true)
