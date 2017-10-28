React = require 'react'
ReactDOM = require 'react-dom'
Main = require './components/Main'
dom = React.createElement

{HashRouter, Route, Redirect} = require 'react-router-dom'

ReactDOM.render(
  dom HashRouter, {},
    dom 'div', className: 'router-only-child',
      dom Route, path: "/", component: require('./components/Main')
      dom Route, path: "/range", component: require('./components/Range')
      dom Route, path: "/subset", component: require('./components/Subset')
      # dom Redirect, from: "/", to: "/main"
  document.getElementsByTagName('main')[0]
)