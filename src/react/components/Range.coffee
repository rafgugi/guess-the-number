React = require 'react'
createReactClass = require 'create-react-class'
combinatoric = require '../combinatoric'
dom = React.createElement

{abs, min, max, log2, ceil, round} = Math
[Yes, No] = ['Yes', 'No']
lieLimit = 16 # limitation of lie by the program

Main = createReactClass
  displayName: 'Main'

  getInitialState: ->
    set: [] # truth set and lie set
    playing: false
    questionLeft: 0

    # input values
    range: 1000
    maxLies: 4 # maximal number of lies
    qa: 1 # query start
    qb: 500 # query end
    qx: Yes # query answer

  componentDidMount: ->
    # @handlePlayButton()

  handleInputNumberChange: (event) ->
    value = parseInt(event.target.value)
    name = event.target.name

    baru = []
    if not isNaN(value)
      baru[name] = abs(value)
    else
      baru[name] = ''
    @setState baru

  handleInputChange: (event) ->
    baru = []
    baru[event.target.name] = event.target.value
    @setState baru

  handleRestartButton: ->
    @setState
      playing: false
      set: []

  handlePlayButton: ->
    {range, maxLies} = @state
    if range isnt '' && maxLies isnt ''
      playing = true
      maxLies = min lieLimit, max 0, maxLies
      questionLeft = ceil(log2(range)) * (maxLies * 2 + 1)
      q = [1, range, Yes] # query
      s = [[1, range, 0]] # range set
      n = [range].concat(0 for i in [0..maxLies - 1] by 1) # state
      w = combinatoric.berlekamp n, questionLeft, maxLies # berlekamp
      wp = 100
      set = [{q, s, n, w, wp}]

      @setState {playing, maxLies, questionLeft, set}

  handleSubmitButton: ->
    if not @queryValidator()
      return
    {set, questionLeft, maxLies} = @state
    h = @generateHistory()
    console.log h
    set.push(h)

    @setState
      set: set
      questionLeft: questionLeft - 1

  queryValidator: ->
    {qa, qb, qx, range} = @state
    1 <= qa <= qb <= range && qx isnt ''
      

  # push a range of history
  #
  # @param array range set
  # @param array channel bohong sekarang
  # @param range awal
  # @param range akhir
  # @param channel asal
  # @param apakah harus ganti channel?
  # @param array channel bohong jika jawaban ya
  # @param array channel bohong jika jawaban tidak
  pusH: ({s, n}, a, b, sx, x, cy, cn) ->
    truth = sx + x
    lie = sx + !x
    if truth <= @state.maxLies
      s.push([a, b, truth])
      n[truth] += b - a + 1
      cy[truth] += b - a + 1
    if lie <= @state.maxLies
      cn[lie] += b - a + 1

  # create a set of history for range query
  generateHistory: ->
    {set, qa, qb, qx, maxLies, questionLeft} = @state

    s = [] # range set
    n = (0 for i in [0..maxLies] by 1) # state vector
    c = [] # state vector from possible answer of judge
    c[Yes] = n.slice(0) # state vector if answer is yes
    c[No] = n.slice(0) # state vector if answer is no

    q = [qa, qb, qx]
    h = {q, s, n, c}

    lastSet = set[set.length - 1]
    for [sa, sb, sx] in lastSet.s # history terakhir
      x = qx is Yes # correctness of range given
      if qb >= sa && qa <= sb
        if qa - 1 >= sa
          @pusH(h, sa, qa - 1, sx, x, c[Yes], c[No]) # A - U (left)
        @pusH(h, max(sa, qa), min(sb, qb), sx, !x, c[Yes], c[No]) # U
        if qb + 1 <= sb
          @pusH(h, qb + 1, sb, sx, x, c[Yes], c[No]) # A - U (right)
      else
        @pusH(h, sa, sb, sx, x, c[Yes], c[No]) # A - U
    h.w = combinatoric.berlekamp n, questionLeft, maxLies
    h.wy = combinatoric.berlekamp c[Yes], questionLeft, maxLies
    h.wn = combinatoric.berlekamp c[No], questionLeft, maxLies
    h.wp = round h.w / lastSet.w * 100
    h.wpy = round h.wy / lastSet.w * 100
    h.wpn = round h.wn / lastSet.w * 100
    h

  render: ->
    {set, playing, range, maxLies, qa, qb, qx, questionLeft, hasError} = @state

    dom 'section', className: 'row',
      dom 'span', className: 'five columns',
        # Initial game
        dom 'div', className: 'row',
          dom 'div', className: 'three columns',
            dom 'label', {}, 'Range [1-n]'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'range'
              onChange: @handleInputNumberChange
              value: range
              disabled: playing
          dom 'div', className: 'two columns',
            dom 'label', {}, 'Lie(s)'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'maxLies'
              onChange: @handleInputNumberChange
              value: maxLies
              disabled: playing
          dom 'div', className: 'three columns',
            dom 'label', {}, 'Query'
            dom 'select',
              className: 'u-full-width'
              name: 'query'
              disabled: true
              dom 'option', value: 'range', 'Range'
          dom 'div', className: 'four columns',
            dom 'label', className: 'u-invisible', 'i'
            if not playing
              dom 'button',
                type: 'button'
                className: 'button-primary'
                onClick: @handlePlayButton
                'Start'
            else
              dom 'button',
                type: 'button'
                className: 'button-danger'
                onClick: @handleRestartButton
                'Restart'

        # Query game
        dom 'div',
          className: "row #{'u-hide' if not playing}"
          dom 'hr'

          # Range query
          dom 'div',
            className: "three columns"
            dom 'label', {}, 'Start'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'qa'
              onChange: @handleInputNumberChange
              value: qa
          dom 'div',
            className: "three columns"
            dom 'label', {}, 'End'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'qb'
              onChange: @handleInputNumberChange
              value: qb

          dom 'div', className: 'two columns',
            dom 'label', {}, 'Answer'
            dom 'select',
              className: 'u-full-width'
              name: 'qx'
              onChange: @handleInputChange
              value: qx
              dom 'option', value: '', disabled: true, ''
              dom 'option', value: Yes, 'Yes'
              dom 'option', value: No, 'No'

          dom 'div', className: 'three columns',
            dom 'label', className: 'u-invisible', 'i'
            dom 'button',
              type: 'button'
              className: 'button-primary'
              onClick: @handleSubmitButton
              'Submit'

        # Hints!
        dom 'span', {},
          dom 'hr'
          dom 'span', {}, "Judge has chosen a number x in the range [1, n]. Guesser
            has to find the number x using m queries range [a, b], then Judge has
            to answer if the number x is inside range [a, b]."
          dom 'br'
          dom 'span', {}, "Firstly, define the range from 1 to n, then press start
            button. You can always restart the game by pressing restart button.
            Then each turn, Guesser give a query range [a, b], Judge then answer
            the query whether the number is inside range [a, b] given by Guesser."
          dom 'br'
          dom 'small', {}, "Judge is allowed to lie #{maxLies} times in
            single game. Program will memorize all queries and answers to ensure
            Judge doesn't lie more than #{maxLies} times."

      # History of truth and lies sets
      dom 'span', className: 'six columns',
        dom 'label', {}, 'Question bar'
        if not playing
          # Example
          dom 'div', className: 'history',
            # Query
            dom 'samp',
              className: 'set',
              title: 'Query (start, end, and answer)'
              "<query_start>-<query_end>:<query_answer>"
            # Set
            dom 'span', {},
              dom 'br'
              dom 'span',
                className: "set bg-color-br-0-muted",
                title: 'Each range and its status'
                "<ch_start> - <ch_end> (<lie_ch>)"
              dom 'i', {}, ' '
            # Channel
            dom 'small', {},
              dom 'br'
              dom 'span',
                title: 'Current channel vector',
                "[ lie_ch_count ]:(<berlekamp_weight>)"
              dom 'br'
              dom 'span',
                className: "color-br-0"
                title: 'Channel if answer is yes'
                "[ lie_ch_yes_count ]:(<yes_berlekamp_weight>)"
              dom 'br'
              dom 'span',
                className: "color-br-#{lieLimit}"
                title: 'Channel if answer is no'
                "[ lie_ch_no_count ]:(<no_berlekamp_weight>)"
        else
          for h, i in set
            dom 'div', key: i, className: 'history',
              # Query
              dom 'samp', className: 'set',
                "#{h.q[0]}-#{h.q[1]}:#{if h.q[2] is Yes then 'Yes' else 'No'}"
              # Set
              dom 'span', {},
                for val, j in h.s
                  dom 'span', key: j,
                    dom 'span',
                      className: "set bg-color-br-#{ceil(val[2] * lieLimit / maxLies)}-muted",
                      "#{val[0]} - #{val[1]} (#{val[2]})"
                    dom 'i', {}, ' '
              # Channel
              dom 'small', {},
                dom 'br'
                dom 'span', {}, "[#{h.n.toString()}]:(#{h.w} #{h.wp}%)"
                if h.c
                  dom 'span', {},
                    dom 'i', {}, ' '
                    dom 'span', className: "color-br-0", "[#{h.c[Yes].toString()}]:(#{h.wy} #{h.wpy}%)"
                    dom 'i', {}, ' '
                    dom 'span', className: "color-br-#{lieLimit}", "[#{h.c[No].toString()}]:(#{h.wn} #{h.wpn}%)"

module.exports = Main