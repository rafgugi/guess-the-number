React = require 'react'
createReactClass = require 'create-react-class'
combinatoric = require '../combinatoric'
dom = React.createElement

{abs, min, max, log2, ceil, round, pow} = Math
lieLimit = 16 # limitation of lie by the program

Subset = createReactClass
  displayName: 'Subset'

  getInitialState: ->
    set: [] # truth set and lie set
    playing: false
    questionLeft: 30
    qx: '1'
    q: '0000000011111111'
    quickQuery: ''
    isAdvance: false

    # input values
    range: 16
    maxLies: 8 # maximal number of lies

  componentWillMount: ->
    # ### only for debugging
    @handlePlayButton()
    @setState
      set: [{"q":"0","qx":"0","n":[16,0,0,0,0,0,0,0,0],"s":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"w":44864192,"wp":100,"questionLeft":30,"fk":382.93053810040755},{"q":"0000000011111111","s":[1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0],"n":[8,8,0,0,0,0,0,0,0],"qx":"1","questionLeft":29,"c":{"0":[8,8,0,0,0,0,0,0,0],"1":[8,8,0,0,0,0,0,0,0]},"w":22432096,"wp":50,"fk":246.00068548512735,"wn":22432096,"wpn":50,"wy":22432096,"wpy":50},{"q":"0000111100001111","s":[2,2,2,2,1,1,1,1,1,1,1,1,0,0,0,0],"n":[4,8,4,0,0,0,0,0,0],"qx":"1","questionLeft":28,"c":{"0":[4,8,4,0,0,0,0,0,0],"1":[4,8,4,0,0,0,0,0,0]},"w":11216048,"wp":50,"fk":159.47753410431685,"wn":11216048,"wpn":50,"wy":11216048,"wpy":50},{"q":"0011001100110011","s":[3,3,2,2,2,2,1,1,2,2,1,1,1,1,0,0],"n":[2,6,6,2,0,0,0,0,0],"qx":"1","questionLeft":27,"c":{"0":[2,6,6,2,0,0,0,0,0],"1":[2,6,6,2,0,0,0,0,0]},"w":5608024,"wp":50,"fk":104.39889734479132,"wn":5608024,"wpn":50,"wy":5608024,"wpy":50},{"q":"0101010101010101","s":[4,3,3,2,3,2,2,1,3,2,2,1,2,1,1,0],"n":[1,4,6,4,1,0,0,0,0],"qx":"1","questionLeft":26,"c":{"0":[1,4,6,4,1,0,0,0,0],"1":[1,4,6,4,1,0,0,0,0]},"w":2804012,"wp":50,"fk":69.06250411644602,"wn":2804012,"wpn":50,"wy":2804012,"wpy":50}]
      questionLeft: 26
    # ###

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

  handleUndoButton: ->
    {set, questionLeft} = @state
    if set.length > 1
      questionLeft++
      last = (set.splice -1, 1)[0]
      {q, qx} = last
      @setState {set, q, qx, questionLeft}

  handlePlayButton: ->
    {range, maxLies, questionLeft} = @state
    if range isnt '' && maxLies isnt ''
      playing = true
      maxLies = min lieLimit, max 0, maxLies
      burstCount = ceil log2 range

      q = '0' # query
      qx = '0' # query
      n = [range].concat(0 for i in [0..maxLies - 1] by 1) # state
      s = (0 for i in [0...range] by 1) # what is x's channel now?
      w = combinatoric.berlekamp n, questionLeft, maxLies # berlekamp
      fk = (pow 2, questionLeft) / (combinatoric.denominator questionLeft, maxLies)
      wp = 100
      set = [{q, qx, n, s, w, wp, questionLeft, fk}]

      @setState {playing, maxLies, questionLeft, set}

  handleSubmitButton: ->
    {set, questionLeft, maxLies, qx, q, range} = @state
    if not @queryValidator qx, q, range
      return
    last = set[set.length - 1]
    h = @generateHistory q, qx, last
    set.push h

    @setState
      set: set
      questionLeft: questionLeft - 1
    console.log 'set', set, JSON.stringify set
    console.log 'questionLeft', questionLeft - 1

  handleAdvancedChange: ->
    @setState
      isAdvance: !@state.isAdvance

  handleQuickButton: ->
    {quickQuery} = @state
    console.log quickQuery

  queryValidator: (qx, q, range) ->
    if q.length isnt range
      console.log "query harus berjumlah #{range} (#{q.length})"
      return false
    else if qx isnt '0' and qx isnt '1'
      console.log "answer harus 0 atau 1 (#{qx})"
      return false
    return true

  # create a set of history for range query
  generateHistory: (q, qx, before) ->
    {set, maxLies, questionLeft} = @state
    questionLeft--

    s = before.s.slice 0
    n = (0 for i in [0..maxLies] by 1) # state vector
    balasN = n.slice 0
    c = 0: null, 1: null
    h = {q, s, n, qx, questionLeft, c}

    for x, i in q
      balasI = s[i] + (x is qx)
      if balasI <= maxLies
        balasN[balasI]++
      s[i] += x isnt qx
      if s[i] <= maxLies
        n[s[i]]++
    h.w = combinatoric.berlekamp n, questionLeft, maxLies
    h.wp = (round h.w * 10000 / before.w) / 100
    h.fk = (pow 2, questionLeft) / (combinatoric.denominator questionLeft, maxLies)
    balasB = combinatoric.berlekamp balasN, questionLeft, maxLies
    balasP = (round balasB * 10000 / before.w) / 100
    if qx is '1'
      c[0] = balasN
      h.wn = balasB
      h.wpn = balasP
      c[1] = h.n
      h.wy = h.w
      h.wpy = h.wp
    else
      c[0] = h.n
      h.wn = h.w
      h.wpn = h.wp
      c[1] = balasN
      h.wy = balasB
      h.wpy = balasP
    h

  render: ->
    {set, playing, range, maxLies, qx, q, questionLeft, quickQuery, isAdvance} = @state

    dom 'section', className: 'row',
      dom 'span', className: 'five columns',
        # Initial game
        dom 'div', className: 'row',
          dom 'div', className: 'three columns',
            dom 'label', {}, 'Range [0,n)'
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
          dom 'div', className: 'two columns',
            dom 'label', {}, 'Turns'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'questionLeft'
              onChange: @handleInputNumberChange
              value: questionLeft
              disabled: playing
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
            className: "twelve columns"
            dom 'label', {}, 'Query'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'q'
              onChange: @handleInputChange
              value: q
          dom 'div',
            className: "three columns"
            dom 'label', {}, 'Answers'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'qx'
              onChange: @handleInputChange
              value: qx

          # Buttons
          dom 'div', className: 'nine columns',
            dom 'label', className: 'u-invisible', 'i'
            dom 'button',
              type: 'button'
              className: 'button-danger'
              onClick: @handleUndoButton
              'Undo'
            dom 'i', {}, ' '
            dom 'button',
              type: 'button'
              className: 'button-primary'
              onClick: @handleSubmitButton
              'Submit'

          # Advance
          dom 'div', className: 'twelve columns',
            dom 'hr'
            dom 'label', {},
              dom 'input',
                type: 'checkbox'
                value: isAdvance
                onChange: @handleAdvancedChange
              dom 'span', className: 'label-body', 'Advanced mode (not yet implemented)'
          if isAdvance
            dom 'div', {},
              dom 'div', className: 'twelve columns',
                dom 'label', {}, 'Quick query'
                dom 'textarea',
                  className: 'u-full-width'
                  name: 'quickQuery'
                  onChange: @handleInputChange
                  value: quickQuery
              dom 'div', className: 'nine columns',
                dom 'button',
                  type: 'button'
                  className: 'button-primary'
                  onClick: @handleQuickButton
                  'Quick'

        # Hints!
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
      dom 'span', className: 'seven columns question-bar',
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
                "[ lie_ch_count ]:(<berlekamp_weight> <percentage_against_other_answer>)"
        else
          for h, i in set
            dom 'div', key: i, className: 'history',
              # Query
              dom 'small', {},
                dom 'samp',
                  className: 'set'
                  "#{h.q}:(#{h.qx}) [#{h.questionLeft}]"
                dom 'br'
                dom 'span', className: 'color-muted', "2^#{h.questionLeft} = #{pow 2, h.questionLeft}"
                dom 'br'
                dom 'span', className: 'color-muted', "fk = #{(round h.fk * 100) / 100}"
                dom 'br'
              # Set
              dom 'span', {},
                for val, j in h.s
                  dom 'small', key: j,
                    dom 'span',
                      className: "set bg-color-muted",
                      "#{j+1}: (#{val})"
                    dom 'i', {}, ' '
              # Channel
              dom 'small', {},
                dom 'br'
                dom 'span', {}, "[#{h.n.toString()}]:(#{h.w} #{h.wp}%)"

module.exports = Subset