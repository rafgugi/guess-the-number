React = require 'react'
createReactClass = require 'create-react-class'
combinatoric = require '../combinatoric'
window.combinatoric = combinatoric
dom = React.createElement

Main = createReactClass
  displayName: 'Main'

  render: ->
    dom 'section', className: 'row',
      dom 'span', className: 'five columns',
        # Initial game
        dom 'p', className: 'row',
          dom 'span', {}, 'Query type: '
          dom 'a', href: '#/range', 'Range'
          dom 'i', {}, ' '
          dom 'a', href: '#/subset', 'Subset'
          dom 'i', {}, ' '
          dom 'a', href: '#/workshop', 'Workshop'

module.exports = Main