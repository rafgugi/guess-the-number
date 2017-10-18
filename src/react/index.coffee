React = require 'react'
ReactDOM = require 'react-dom'
Main = require './components/Main'
dom = React.createElement

ReactDOM.render(
  dom Main
  document.getElementsByTagName('main')[0]
)