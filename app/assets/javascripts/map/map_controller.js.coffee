angular.module("map").controller "Map", [
  '$scope', '$http', '$location', '$route', '$routeParams', 'MapBase', 'MapUtilities'
  ($scope, $http, $location, $route, $routeParams, MapBase, MapUtilities) ->
    $scope.statistics = {}
    mapDataEndPoint = "/markers.json"
    new MapBase($scope, $http, $location, $route, $routeParams, mapDataEndPoint, MapUtilities)
]
