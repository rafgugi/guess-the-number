React = require 'react'
dom = React.createElement

Main = React.createClass
  displayName: 'Main'

  getInitialState: ->
    n: 0 # range
    set: [] # truth set and lie set
    # set: [[[1, 1000, 1], [1, 1000, 0]], [[1, 500, 0], [1, 500, 1], [501, 1000, 0]]]

    # input values
    rangeInput: ''
    qaInput: ''
    qbInput: ''
    qxInput: ''

  componentWillMount: ->

  componentDidMount: ->

  # inputs dom
  rangeInput: null
  qaInput: null
  qbInput: null
  qxInput: null

  handleInputNumberChange: (event)->
    target = event.target
    value = parseInt(target.value)
    name = target.name

    baru = []
    if target.value is ''
      baru[name] = ''
    else if not isNaN(value)
      baru[name] = Math.abs(value)
    @setState baru

  handleResetButton: ->
    @setState
      n: 0
      set: []

  handlePlayButton: ->
    n = @state.rangeInput
    if n isnt ''
      @setState
        n: n
        set: [[[1, n, 1], [1, n, 0]]]

  render: ->
    dom 'section', className: 'row',
      dom 'span', className: 'five columns',

        dom 'div', {},
          dom 'label', {}, 'Range [1-n]'
          dom 'input',
            type: 'text'
            onChange: @handleInputNumberChange
            name: 'rangeInput'
            value: @state.rangeInput
            disabled: @state.set.length isnt 0
            ref: (input) => @rangeInput = input
          dom 'i', {}, ' '
          if @state.set.length is 0
            dom 'button',
              type: 'button'
              className: 'button-primary'
              onClick: @handlePlayButton
              'Start'
          else
            dom 'button',
              type: 'button'
              className: 'button-danger'
              onClick: @handleResetButton
              'Restart'

        # Query game
        dom 'hr'
        dom 'div', className: 'row',
          dom 'div', className: 'three columns',
            dom 'label', {}, 'Start'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              onChange: @handleInputNumberChange
              name: 'qaInput'
              value: @state.qaInput
              disabled: @state.set.length is 0
              ref: (input) => @qaInput = input

          dom 'div', className: 'three columns',
            dom 'label', {}, 'End'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              onChange: @handleInputNumberChange
              name: 'qbInput'
              value: @state.qbInput
              disabled: @state.set.length is 0
              ref: (input) => @qbInput = input

          dom 'div', className: 'three columns',
            dom 'label', {}, 'Answer'
            dom 'select',
              className: 'u-full-width'
              name: 'qxInput'
              disabled: @state.set.length is 0
              ref: (input) => @qxInput = input
              dom 'option', key: 0, value: 0, 'No'
              dom 'option', key: 1, value: 1, 'Yes'

          dom 'div', className: 'three columns',
            dom 'label', className: 'u-invisible', '&nbsp;'
            dom 'button',
              type: 'button'
              className: 'button-primary u-full-width'
              disabled: @state.set.length is 0
              onClick: @handlePlayButton
              'Submit'

      # History of truth and lie sets
      dom 'span', className: 'six columns',
        dom 'div', {}, 'State set'
        for history, i in @state.set
          dom 'div', key: i, className: 'history',
            for set, j in history
              if j is 0
                dom 'span', key: j, className: 'set color-muted',
                  "#{set[0]} - #{set[1]}: #{if set[2] then 'Yes' else 'No'}"
              else
                dom 'span', key: j,
                  dom 'span',
                    className: "set color-#{set[2] * 6}-muted",
                    "#{set[0]} - #{set[1]}"
                  dom 'i', {}, ' '

module.exports = Main