angular.module("map").directive "visualisation", ->
  (scope, element, attr) ->

    link = {}
    node = {}
    width = 700
    height = 250

    tick = ->
      link.attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)

      node.attr("cx", (d) -> d.x)
        .attr("cy", (d) -> d.y)

    force = d3.layout.force()
      .on("tick", tick)
      .gravity(0)
      .charge(-60)
      .size([width, height])

    visualisation = d3.select("#" + element.attr('id')).append("svg:svg")
      .attr("width", width)
      .attr("height", height)

    resetMarkers = ->
      for marker in scope.markers
        marker.fixed = false
      scope.currentMarker.fixed = true
      scope.currentMarker.px = width / 2
      scope.currentMarker.py = height / 2

    update = ->
      resetMarkers()
      nodes = flatten(scope.currentMarker)

      links = d3.layout.tree().links(nodes)

      # Restart the force layout.
      force.nodes(nodes)
        .links(links)
        .start()

      # Update the links…
      link = visualisation.selectAll("line.link").data(links, (d) -> d.target.id)

      # Enter any new links.
      link.enter()
        .insert("svg:line", ".node")
        .attr("class", "link")
        .attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)

      # Exit any old links.
      link.exit().remove()

      # Update the nodes…
      node = visualisation.selectAll("circle.node")
        .data(nodes, (d) -> d.id)
        .attr("class", (d) -> "node " + if d == scope.currentMarker then "root" else "child")
        .attr("r", (d) -> if d == scope.currentMarker then 10 else 5)

      # Enter any new nodes.
      node.enter().append("svg:circle")
        .attr("class", (d) -> "node " + if d == scope.currentMarker then "root" else "child")
        .attr("cx", (d) -> d.x * 2)
        .attr("cy", (d) -> d.y)
        .attr("r", (d) -> if d == scope.currentMarker then 10 else 5)
        .on("mouseover", (d) ->
          scope.showHoveredPoint(d)
          d.fixed = true
        )
        .on("mouseout", (d) ->
          scope.hideHoveredPoint()
          d.fixed = false if d != scope.currentMarker
        )
        .on("click", (d) ->
          scope.clickHoveredPoint(d)
        )

      # Exit any old nodes.
      node.exit().remove()

    # Returns a list of all nodes under the root.
    flatten = (root) ->
      recurse = (node) ->
        node.children.forEach recurse if node.children
        node.id = ++i unless node.id
        nodes.push node
      nodes = []
      i = 0
      recurse root
      nodes

    scope.$watch 'currentMarker', (marker) ->
      if(marker)
        update()
