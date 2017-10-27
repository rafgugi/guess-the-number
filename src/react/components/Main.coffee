React = require 'react'
createReactClass = require 'create-react-class'
combinatoric = require '../combinatoric'
window.combinatoric = combinatoric
dom = React.createElement

{abs, min, max, log2, ceil} = Math
[Yes, No] = ['Yes', 'No']
lieLimit = 16 # limitation of lie by the program

Main = createReactClass
  displayName: 'Main'

  getInitialState: ->
    set: [] # truth set and lie set
    playing: false

    # input values
    range: 1000
    maxLies: 4 # maximal number of lies
    query: 'subset' # query type ('range' / 'subset')
    qa: 1 # query start
    qb: 500 # query end
    qx: Yes # query answer
    questionLeft: 0

    hasError: [] # inputs that have error

  componentDidMount: ->
    @handlePlayButton()

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

  handleResetButton: ->
    @setState
      playing: false
      set: []

  handlePlayButton: ->
    {range, maxLies, query} = @state
    if range isnt '' && maxLies isnt '' && query isnt ''
      playing = true
      maxLies = min(lieLimit, max(0, maxLies))
      questionLeft = ceil(log2(range)) * (maxLies * 2 + 1)
      if @state.query is 'range'
        q = [1, range, Yes] # query
        s = [[1, range, 0]] # range set
        n = [range].concat(0 for i in [0..maxLies - 1]) # state
        w = combinatoric.berlekamp(n, questionLeft, maxLies) # berlekamp
        set = [{q, s, n, w}]
      else if @state.query is 'subset'
        q = (0 for i in [0..maxLies]) # query
        n = [range].concat(0 for i in [0..maxLies - 1]) # state
        w = combinatoric.berlekamp(n, questionLeft, maxLies) # berlekamp
        set = [{q, n, w}]
        stateInput = []
        for i in [0..maxLies]
          stateInput["q#{i}"] = n[i]
        @setState stateInput

      @setState {playing, maxLies, questionLeft, set}

  handleSubmitButton: ->
    if not @queryValidator()
      return
    {set, questionLeft, maxLies} = @state
    if @state.query is 'range'
      h = @generateHistory()
    else if @state.query is 'subset'
      h = @generateHistorySubset()
      stateInput = []
      for i in [0..maxLies]
        stateInput["q#{i}"] = h.n[i]
      @setState stateInput
    console.log h
    set.push(h)

    @setState
      set: set
      questionLeft: questionLeft - 1

  queryValidator: ->
    if @state.query is 'range'
      {qa, qb, qx, range} = @state
      1 <= qa <= qb <= range && qx isnt ''
    else if @state.query is 'subset'
      {qx, maxLies, set} = @state
      if qx is '' then return false
      last = set[set.length - 1]
      hasError = []
      for i in [0..maxLies]
        if @state["q#{i}"] > last.n[i]
          hasError.push i
      @setState {hasError}
      return hasError.length <= 0
      

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
    n = (0 for i in [0..maxLies]) # state vector
    c = [] # state vector from possible answer of judge
    c[Yes] = n.slice(0) # state vector if answer is yes
    c[No] = n.slice(0) # state vector if answer is no

    q = [qa, qb, qx]
    h = {q, s, n, c}

    for [sa, sb, sx] in set[set.length - 1].s # history terakhir
      x = qx is Yes # correctness of range given
      if qb >= sa && qa <= sb
        if qa - 1 >= sa
          @pusH(h, sa, qa - 1, sx, x, c[Yes], c[No]) # A - U (left)
        @pusH(h, max(sa, qa), min(sb, qb), sx, !x, c[Yes], c[No]) # U
        if qb + 1 <= sb
          @pusH(h, qb + 1, sb, sx, x, c[Yes], c[No]) # A - U (right)
      else
        @pusH(h, sa, sb, sx, x, c[Yes], c[No]) # A - U
    h.w = combinatoric.berlekamp(n, questionLeft, maxLies)
    h.wy = combinatoric.berlekamp(c[Yes], questionLeft, maxLies)
    h.wn = combinatoric.berlekamp(c[No], questionLeft, maxLies)
    h

  generateHistorySubset: ->
    {set, qx, maxLies, questionLeft} = @state
    last = set[set.length - 1].n
    beforeY = 0
    beforeN = 0
    q = []
    c = Yes: [], No: [] # state vector from possible answer of judge
    for i in [0..maxLies]
      q[i] = @state["q#{i}"]
      # now
      nowY = last[i] + beforeY
      nowN = last[i] + beforeN
      # lie
      beforeY = nowY - q[i] - beforeY
      beforeN = q[i]
      # truth
      c[Yes][i] = nowY - beforeY
      c[No][i] = nowN - beforeN
    n = if qx is Yes then c[Yes] else c[No]
    h = {n, q, c}
    h.w = combinatoric.berlekamp(n, questionLeft, maxLies)
    h.wy = combinatoric.berlekamp(c[Yes], questionLeft, maxLies)
    h.wn = combinatoric.berlekamp(c[No], questionLeft, maxLies)
    h

  render: ->
    {set, playing, range, maxLies, query, qa, qb, qx, questionLeft, hasError} = @state

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
              onChange: @handleInputChange
              value: query
              disabled: playing
              dom 'option', value: '', disabled: true, ''
              dom 'option', value: 'range', 'Range'
              dom 'option', value: 'subset', 'Subset'
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
                onClick: @handleResetButton
                'Restart'

        # Query game
        dom 'div',
          className: "row #{'u-hide' if not playing}"
          dom 'hr'

          # Range query
          dom 'div',
            className: "three columns #{'u-hide' if query isnt 'range'}"
            dom 'label', {}, 'Start'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'qa'
              onChange: @handleInputNumberChange
              value: qa
          dom 'div',
            className: "three columns #{'u-hide' if query isnt 'range'}"
            dom 'label', {}, 'End'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'qb'
              onChange: @handleInputNumberChange
              value: qb

          # Subset query
          for i in [0..maxLies]
            dom 'div',
              key: i
              className: "two columns #{'u-hide' if query isnt 'subset'}"
              dom 'label', {}, "#{i} lie#{if i > 1 then 's' else ''}"
              dom 'input',
                type: 'text'
                className: "u-full-width #{if hasError.indexOf(i) > -1 then 'has-error'}"
                name: "q#{i}"
                onChange: @handleInputNumberChange
                value: @state["q#{i}"] or 0

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
              className: 'button' + if playing then '-primary'
              onClick: @handleSubmitButton
              'Submit'

        # Hints!
        if query is 'range'
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
        else if query is 'subset'
          dom 'span', {},
            dom 'hr'
            dom 'span', {}, "Judge has chosen a number x in the range [1, n]. Guesser
              has to find the number x using m queries subset Q={q1, q2, ...}, then Judge has
              to answer if the number x is inside subset Q."
            dom 'br'
            dom 'small', {}, "Judge is allowed to lie #{maxLies} times in
              single game. Program will memorize all queries and answers to ensure
              Judge doesn't lie more than #{maxLies} times."

      # History of truth and lies sets
      dom 'span', className: 'six columns',
        dom 'label', {}, 'Question bar'
        if not playing
          # Example
          dom 'div', key: i, className: 'history',
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
        else if query is 'range'
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
                dom 'span', {}, "[#{h.n.toString()}]:(#{h.w})"
                if h.c
                  dom 'span', {},
                    dom 'i', {}, ' '
                    dom 'span', className: "color-br-0", "[#{h.c[Yes].toString()}]:(#{h.wy})"
                    dom 'i', {}, ' '
                    dom 'span', className: "color-br-#{lieLimit}", "[#{h.c[No].toString()}]:(#{h.wn})"
        else if query is 'subset'
          for h, i in set
            dom 'div', key: i, className: 'history',
              # Query
              if h.q
                dom 'span', {},
                  for val, j in h.q
                    dom 'span', key: j,
                      dom 'span',
                        className: "set bg-color-br-#{ceil(j * lieLimit / maxLies)}-muted",
                        "(#{j}):#{val}"
                      dom 'i', {}, ' '
              # Channel
              dom 'small', {},
                dom 'span', {}, "[#{h.n.toString()}]:(#{h.w})"
                if h.c
                  dom 'span', {},
                    dom 'i', {}, ' '
                    dom 'span', className: "color-br-0", "[#{h.c[Yes].toString()}]:(#{h.wy})"
                    dom 'i', {}, ' '
                    dom 'span', className: "color-br-#{lieLimit}", "[#{h.c[No].toString()}]:(#{h.wn})"

module.exports = Main