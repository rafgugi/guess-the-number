React = require 'react'
dom = React.createElement
{abs, min, max} = Math
[No, Yes] = ['0', '1']
lieLimit = 16 # limitation of lie by the program

Main = React.createClass
  displayName: 'Main'

  getInitialState: ->
    set: [] # truth set and lie set

    # input values
    range: 1000
    maxLies: 2 # maximal number of lies
    qa: 1 # query start
    qb: 500 # query end
    qx: No # query answer

  componentDidMount: ->
    # @handlePlayButton()

  handleInputNumberChange: (event)->
    value = parseInt(event.target.value)
    name = event.target.name

    baru = []
    if event.target.value is ''
      baru[name] = ''
    else if not isNaN(value)
      baru[name] = abs(value)
    @setState baru

  handleInputChange: (event)->
    baru = []
    baru[event.target.name] = event.target.value
    @setState baru

  handleResetButton: ->
    @setState set: []

  handlePlayButton: ->
    {range, maxLies} = @state
    if range isnt '' && maxLies isnt ''
      @setState
        set: [
          q: [1, range, Yes]
          s: [[1, range, 0]]
        ]
        maxLies: min(lieLimit, max(0, maxLies))

  handleSubmitButton: ->
    if not @queryValidator()
      return
    h = @generateHistory()
    {set} = @state
    set.push(h)
    @setState set: set

  queryValidator: ->
    {qa, qb, qx, range} = @state
    1 <= qa <= qb <= range && qx isnt ''

  generateHistory: ->
    {set, qa, qb, qx, maxLies} = @state
    h = []
    last = set[set.length - 1]
    for [sa, sb, sx] in last.s
      x = qx is Yes # correctness of range given
      if qb >= sa && qa <= sb
        if qa - 1 >= sa
          if sx + x <= maxLies # A - U (left)
            h.push([sa, qa - 1, sx + x])
        if sx + !x <= maxLies # U
          h.push([max(sa, qa), min(sb, qb), sx + !x])
        if qb + 1 <= sb
          if sx + x <= maxLies # A - U (right)
            h.push([qb + 1, sb, sx + x])
      else
        if sx + x <= maxLies # A - U
          h.push([sa, sb, sx + x])
    return {q: [qa, qb, qx], s: h}

  render: ->
    dom 'section', className: 'row',
      dom 'span', className: 'five columns',
        dom 'div', className: 'row',
          dom 'div', className: 'five columns',
            dom 'label', {}, 'Range [1-n]'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'range'
              onChange: @handleInputNumberChange
              value: @state.range
              disabled: @state.set.length isnt 0
          dom 'div', className: 'two columns',
            dom 'label', {}, 'Lie(s)'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'maxLies'
              onChange: @handleInputNumberChange
              value: @state.maxLies
              disabled: @state.set.length isnt 0
          dom 'div', className: 'four columns',
            dom 'label', className: 'u-invisible', 'i'
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

          dom 'div', className: 'two columns',
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
              className: 'button-primary'
              disabled: @state.set.length is 0
              onClick: @handleSubmitButton
              'Submit'

        dom 'hr'
        dom 'span', {}, "Judge has chosen a number x in the range [1, n]. Guesser
          has to find the number x using q queries range [a, b], then Judge has
          to answer if the number x is inside range [a, b]."
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
            dom 'span', className: 'set color-muted',
              "#{history.q[0]} - #{history.q[1]}: #{if history.q[2] is Yes then 'Yes' else 'No'}"
            dom 'span', {},
              for set, j in history.s
                dom 'span', key: j,
                  dom 'span',
                    className: "set color-#{(set[2] * 5) % 12}-muted",
                    "#{set[0]} - #{set[1]} (#{set[2]})"
                  dom 'i', {}, ' '

module.exports = Main