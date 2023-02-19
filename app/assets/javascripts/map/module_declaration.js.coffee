app = angular.module("map", [])

app.config [
  '$locationProvider', '$routeProvider'
  ($locationProvider, $routeProvider) ->
    $locationProvider.html5Mode(true)
    $routeProvider.when("/map/:markerId", {controller: "Map"})
]

app.filter "toLatlon", ->
  (input) ->
    Number(input).toFixed(2)

app.filter "formatDistance", ->
  (input) ->
    numeral(input).format('0,0')

app.filter "formatDecimal", ->
  (input) ->
    numeral(input).format('0.00')
