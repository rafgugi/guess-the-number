React = require 'react'
dom = React.createElement
Yes = '1'
No = '0'

Main = React.createClass
  displayName: 'Main'

  getInitialState: ->
    n: 0 # range
    set: [] # truth set and lie set
    # set: [[[1, 1000, 1], [1, 1000, 0]], [[1, 500, 0], [1, 500, 1], [501, 1000, 0]]]

    # input values
    rangeInput: 1000
    qaInput: 1
    qbInput: 500
    qxInput: No

  componentWillMount: ->

  componentDidMount: ->
    @handlePlayButton()

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

  handleInputChange: (event)->
    baru = []
    baru[event.target.name] = event.target.value
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

  handleSubmitButton: ->
    if @state.qaInput is ''
      return null
    if @state.qbInput is ''
      return null
    if @state.qxInput is ''
      return null
    set = @state.set
    h = @generateHistory()
    console.log 'generateHistory', h
    set.push(h)
    @setState set: set

  generateHistory: ->
    set = @state.set
    qa = @state.qaInput
    qb = @state.qbInput
    qx = @state.qxInput
    h = []
    last = set[set.length - 1]
    for i in [1...last.length]
      s = last[i]
      # console.log 'h', h[0]
      # console.log 's', s
      if qx is Yes # the answer is Yes
        if s[2] is 1 # the set is lie
          if qb >= s[0] && qa <= s[1]
            h.push([Math.max(s[0], qa), Math.min(s[1], qb), 1]) # add to lie set
        else if s[2] is 0 # the set is truth
          if qb >= s[0] && qa <= s[1]
            if qa - 1 >= s[0]
              h.push([s[0], qa - 1, 1]) # add to lie set
            h.push([Math.max(s[0], qa), Math.min(s[1], qb), 0]) # add to truth set
            if qb + 1 <= s[1]
              h.push([qb + 1, s[1], 1]) # add to lie set
          else
            h.push([s[0], s[1], 1]) # add to lie set
      else if qx is No # the answer is No
        if s[2] is 1 # the set is lie
          if qb >= s[0] && qa <= s[1]
            if qa - 1 >= s[0]
              h.push([s[0], qa - 1, 1]) # add to lie set
            if qb + 1 <= s[1]
              h.push([qb + 1, s[1], 1]) # add to lie set
          else
            h.push([s[0], s[1], 1]) # add to lie set
        else if s[2] is 0 # the set is truth
          if qb >= s[0] && qa <= s[1]
            if qa - 1 >= s[0]
              h.push([s[0], qa - 1, 0]) # add to lie set
            h.push([Math.max(s[0], qa), Math.min(s[1], qb), 1]) # add to truth set
            if qb + 1 <= s[1]
              h.push([qb + 1, s[1], 0]) # add to lie set
          else
            h.push([s[0], s[1], 0]) # add to lie set
      else
        console.log 'answer is undefined'
        console.log qx
    h.unshift([qa, qb, qx])
    console.log 'return h', h
    return h

  render: ->
    dom 'section', className: 'row',
      dom 'span', className: 'five columns',

        dom 'div', {},
          dom 'label', {}, 'Range [1-n]'
          dom 'input',
            type: 'text'
            name: 'rangeInput'
            onChange: @handleInputNumberChange
            value: @state.rangeInput
            disabled: @state.set.length isnt 0
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
              name: 'qaInput'
              onChange: @handleInputNumberChange
              value: @state.qaInput
              disabled: @state.set.length is 0

          dom 'div', className: 'three columns',
            dom 'label', {}, 'End'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'qbInput'
              onChange: @handleInputNumberChange
              value: @state.qbInput
              disabled: @state.set.length is 0

          dom 'div', className: 'three columns',
            dom 'label', {}, 'Answer'
            dom 'select',
              className: 'u-full-width'
              name: 'qxInput'
              onChange: @handleInputChange
              value: @state.qxInput
              disabled: @state.set.length is 0
              dom 'option', key: -1, value: '', disabled: true, ''
              dom 'option', key: 0, value: 0, 'No'
              dom 'option', key: 1, value: 1, 'Yes'

          dom 'div', className: 'three columns',
            dom 'label', className: 'u-invisible', 'i'
            dom 'button',
              type: 'button'
              className: 'button-primary u-full-width'
              disabled: @state.set.length is 0
              onClick: @handleSubmitButton
              'Submit'

      # History of truth and lie sets
      dom 'span', className: 'six columns',
        dom 'div', {}, 'Question bar'
        for history, i in @state.set
          dom 'div', key: i, className: 'history',
            for set, j in history
              if j is 0
                dom 'span', key: j, className: 'set color-muted',
                  "#{set[0]} - #{set[1]}: #{if set[2] is Yes then 'yes' else 'no'}"
              else
                dom 'span', key: j,
                  dom 'span',
                    className: "set color-#{set[2] * 6}-muted",
                    "#{set[0]} - #{set[1]}"
                  dom 'i', {}, ' '

module.exports = Main