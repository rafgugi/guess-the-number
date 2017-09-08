React = require 'react'
dom = React.createElement
Yes = '1'
No = '0'

Main = React.createClass
  displayName: 'Main'

  getInitialState: ->
    n: 0 # range
    set: [] # truth set and lie set
    maxLies: 2 # maximal number of lies

    # input values
    range: 1000
    qa: 1
    qb: 500
    qx: No

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
    n = @state.range
    if n isnt ''
      @setState
        n: n
        set: [[[1, n, 1], [1, n, 0]]]

  handleSubmitButton: ->
    if @state.qa is ''
      return null
    if @state.qb is ''
      return null
    if @state.qx is ''
      return null
    set = @state.set
    h = @generateHistory()
    console.log 'generateHistory', h
    set.push(h)
    @setState set: set

  generateHistory: ->
    {set, qa, qb, qx, maxLies} = @state
    h = []
    last = set[set.length - 1]
    for i in [1...last.length]
      [sa, sb, sx] = last[i]
      x = qx is Yes # correctness of range given
      if qb >= sa && qa <= sb
        if qa - 1 >= sa
          if sx + x <= maxLies
            h.push([sa, qa - 1, sx + x]) # A - U
        if sx + !x <= maxLies
          h.push([Math.max(sa, qa), Math.min(sb, qb), sx + !x]) # U
        if qb + 1 <= sb
          if sx + x <= maxLies
            h.push([qb + 1, sb, sx + x]) # A - U
      else
        if sx + x <= maxLies
          h.push([sa, sb, sx + x]) # A - U
    h.unshift([qa, qb, qx])
    return h

  render: ->
    dom 'section', className: 'row',
      dom 'span', className: 'five columns',
        dom 'div', {},
          dom 'label', {}, 'Range [1-n]'
          dom 'input',
            type: 'text'
            name: 'range'
            onChange: @handleInputNumberChange
            value: @state.range
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
              name: 'qa'
              onChange: @handleInputNumberChange
              value: @state.qa
              disabled: @state.set.length is 0

          dom 'div', className: 'three columns',
            dom 'label', {}, 'End'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'qb'
              onChange: @handleInputNumberChange
              value: @state.qb
              disabled: @state.set.length is 0

          dom 'div', className: 'three columns',
            dom 'label', {}, 'Answer'
            dom 'select',
              className: 'u-full-width'
              name: 'qx'
              onChange: @handleInputChange
              value: @state.qx
              disabled: @state.set.length is 0
              dom 'option', key: -1, value: '', disabled: true, ''
              dom 'option', key: 1, value: 1, 'Yes'
              dom 'option', key: 0, value: 0, 'No'

          dom 'div', className: 'three columns',
            dom 'label', className: 'u-invisible', 'i'
            dom 'button',
              type: 'button'
              className: 'button-primary u-full-width'
              disabled: @state.set.length is 0
              onClick: @handleSubmitButton
              'Submit'

        dom 'hr'
        dom 'span', {}, "Judge has chosen a number x in the range [1, n]. Guesser
          has to find the number x using query range [a, b], then judge has to
          answer if the number is inside range [a, b]."
        dom 'br'
        dom 'span', {}, "Firstly, define the range from 1 to n, then press start
          button. You can always restart the game by pressing restart button.
          Then each turn, Guesser give a query range [a, b], Judge then answer
          the query whether the number is inside range [a, b] given by Guesser."
        dom 'br'
        dom 'small', {}, "Judge is allowed to lie #{@state.maxLies} times in
          single game. Program will memorize all queries and answers to ensure
          Judge doesn't lie more than #{@state.maxLies} times"

      # History of truth and lie sets
      dom 'span', className: 'six columns',
        dom 'label', {}, 'Question bar'
        for history, i in @state.set
          dom 'div', key: i, className: 'history',
            for set, j in history
              if j is 0
                dom 'span', key: j, className: 'set color-muted',
                  "#{set[0]} - #{set[1]}: #{if set[2] is Yes then 'Yes' else 'No'}"
              else
                dom 'span', key: j,
                  dom 'span',
                    className: "set color-#{(set[2] * 5) % 12}-muted",
                    "#{set[0]} - #{set[1]}"
                  dom 'i', {}, ' '

module.exports = Main