React = require 'react'
createReactClass = require 'create-react-class'
combinatoric = require '../combinatoric'
window.combinatoric = combinatoric
dom = React.createElement

{abs, min, max, log2, ceil} = Math
[No, Yes] = ['0', '1']
lieLimit = 16 # limitation of lie by the program

Main = createReactClass
  displayName: 'Main'

  getInitialState: ->
    set: [] # truth set and lie set

    # input values
    range: 1000
    maxLies: 2 # maximal number of lies
    qa: 1 # query start
    qb: 500 # query end
    qx: No # query answer
    questionLeft: 0

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
      maxLies = min(lieLimit, max(0, maxLies))
      @setState
        set: [
          q: [1, range, Yes]
          s: [[1, range, 0]]
          n: [range].concat(0 for i in [0..maxLies - 1])
          w: 0

        ]
        maxLies: maxLies
        questionLeft: ceil(log2(range)) * (maxLies * 2 + 1)

  handleSubmitButton: ->
    if not @queryValidator()
      return
    h = @generateHistory()
    {set, questionLeft} = @state
    set.push(h)
    @setState
      set: set
      questionLeft: questionLeft - 1

  queryValidator: ->
    {qa, qb, qx, range} = @state
    1 <= qa <= qb <= range && qx isnt ''

  # push a range of history
  pusH: ({s, n}, a, b, sx, x, cy, cn) ->
    truth = sx + x
    lie = sx + !x
    if truth <= @state.maxLies
      s.push([a, b, truth])
      n[truth] += b - a + 1
      cy[truth] += b - a + 1
    if lie <= @state.maxLies
      cn[lie] += b - a + 1

  # create a set of history
  generateHistory: ->
    {set, qa, qb, qx, maxLies, questionLeft} = @state
    s = [] # range set
    n = (0 for i in [0..maxLies]) # state vector
    c = [] # state vector from possible answer of judge
    c[Yes] = n.slice(0) # state vector if answer is yes
    c[No] = n.slice(0) # state vector if answer is no
    q = [qa, qb, qx]
    h = {q, s, n, c}
    last = set[set.length - 1]

    for [sa, sb, sx] in last.s
      x = qx is Yes # correctness of range given
      if qb >= sa && qa <= sb
        if qa - 1 >= sa
          @pusH(h, sa, qa - 1, sx, x, c[Yes], c[No]) # A - U (left)
        @pusH(h, max(sa, qa), min(sb, qb), sx, !x, c[Yes], c[No]) # U
        if qb + 1 <= sb
          @pusH(h, qb + 1, sb, sx, x, c[Yes], c[No]) # A - U (right)
      else
        @pusH(h, sa, sb, sx, x, c[Yes], c[No]) # A - U
    h.w = @berlekamp(n, questionLeft, maxLies)
    h.wy = @berlekamp(c[Yes], questionLeft, maxLies)
    h.wn = @berlekamp(c[No], questionLeft, maxLies)
    console.log h
    return h

  # hitung berlekamp weight
  berlekamp: (vector, questionLeft, maxLies) ->
    weight = 0
    for x, i in vector
      weight += x * combinatoric.denominator(questionLeft, maxLies - i)
    weight

  render: ->
    dom 'section', className: 'row',
      dom 'span', className: 'five columns',
        # 
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
              dom 'option', value: '', disabled: true, ''
              dom 'option', value: 1, 'Yes'
              dom 'option', value: 0, 'No'

          dom 'div', className: 'three columns',
            dom 'label', className: 'u-invisible', 'i'
            dom 'button',
              type: 'button'
              className: 'button' + if @state.set.length isnt 0 then '-primary'
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
          Judge doesn't lie more than #{@state.maxLies} times."

      # History of truth and lies sets
      dom 'span', className: 'six columns',
        dom 'label', {}, 'Question bar'
        if @state.set.length <= 0
          # Example
          dom 'div', key: i, className: 'history',
            # Query
            dom 'samp', className: 'set',
              "<query_start>-<query_end>:<query_answer>"
            # Set
            dom 'span', {},
              dom 'br'
              dom 'span',
                className: "set bg-color-br-0-muted",
                "<ch_start> - <ch_end> (<lie_ch>)"
              dom 'i', {}, ' '
            # Channel
            dom 'small', {},
              dom 'br'
              dom 'span', {}, "[ lie_ch_count ]: (<berlekamp_weight>)"
              dom 'br'
              dom 'span', className: "color-br-0", "[ lie_ch_yes_count ]: (<yes_berlekamp_weight>)"
              dom 'br'
              dom 'span', className: "color-br-#{lieLimit}", "[ lie_ch_no_count ]: (<no_berlekamp_weight>)"
        else for h, i in @state.set
          dom 'div', key: i, className: 'history',
            # Query
            dom 'samp', className: 'set',
              "#{h.q[0]}-#{h.q[1]}:#{if h.q[2] is Yes then 'Yes' else 'No'}"
            # Set
            dom 'span', {},
              for set, j in h.s
                dom 'span', key: j,
                  dom 'span',
                    className: "set bg-color-br-#{ceil(set[2] * lieLimit / @state.maxLies)}-muted",
                    "#{set[0]} - #{set[1]} (#{set[2]})"
                  dom 'i', {}, ' '
            # Channel
            dom 'small', {},
              dom 'br'
              dom 'span', {}, "[#{h.n.toString()}]: (#{h.w})"
              if h.w
                dom 'span', {},
                  dom 'i', {}, ' '
                  dom 'span', className: "color-br-0", "[#{h.c[Yes].toString()}]: (#{h.wy})"
                  dom 'i', {}, ' '
                  dom 'span', className: "color-br-#{lieLimit}", "[#{h.c[No].toString()}]: (#{h.wn})"

module.exports = Main