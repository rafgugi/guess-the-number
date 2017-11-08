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
    questionLeft: 0
    qx: '1'
    q: '0000000011111111'

    # input values
    range: 16
    maxLies: 6 # maximal number of lies

  componentWillMount: ->
    # only for debugging
    @handlePlayButton()
    @setState
      set: [{"q":"0","qx":"0","n":[16,0,0,0,0,0,0],"s":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"w":46290624,"wp":100,"questionLeft":52,"fk":1556634752.5997477},{"q":"0000000011111111","s":[1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0],"n":[8,8,0,0,0,0,0],"qx":"1","questionLeft":51,"c":{"0":[8,8,0,0,0,0,0],"1":[8,8,0,0,0,0,0]},"w":23145312,"wp":50,"fk":859100951.6896828,"wn":23145312,"wpn":50,"wy":23145312,"wpy":50},{"q":"0000111100001111","s":[2,2,2,2,1,1,1,1,1,1,1,1,0,0,0,0],"n":[4,8,4,0,0,0,0],"qx":"1","questionLeft":50,"c":{"0":[4,8,4,0,0,0,0],"1":[4,8,4,0,0,0,0]},"w":11572656,"wp":50,"fk":475076080.8910553,"wn":11572656,"wpn":50,"wy":11572656,"wpy":50},{"q":"0011001100110011","s":[3,3,2,2,2,2,1,1,2,2,1,1,1,1,0,0],"n":[2,6,6,2,0,0,0],"qx":"1","questionLeft":49,"c":{"0":[2,6,6,2,0,0,0],"1":[2,6,6,2,0,0,0]},"w":5786328,"wp":50,"fk":263256322.8853737,"wn":5786328,"wpn":50,"wy":5786328,"wpy":50},{"q":"0101010101010101","s":[4,3,3,2,3,2,2,1,3,2,2,1,2,1,1,0],"n":[1,4,6,4,1,0,0],"qx":"1","questionLeft":48,"c":{"0":[1,4,6,4,1,0,0],"1":[1,4,6,4,1,0,0]},"w":2893164,"wp":50,"fk":146193654.84461117,"wn":2893164,"wpn":50,"wy":2893164,"wpy":50}]
      questionLeft: 48
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
    {range, maxLies} = @state
    if range isnt '' && maxLies isnt ''
      playing = true
      maxLies = min lieLimit, max 0, maxLies
      burstCount = ceil log2 range
      questionLeft = burstCount * (maxLies * 2 + 1)

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
    if not @queryValidator()
      return
    {set, questionLeft, maxLies, qx, q} = @state
    last = set[set.length - 1]
    h = @generateHistory q, qx, last
    set.push h

    @setState
      set: set
      questionLeft: questionLeft - 1
    console.log 'set', set, JSON.stringify set
    console.log 'questionLeft', questionLeft - 1

  queryValidator: ->
    {qx, q, range} = @state
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
    h.wp = round h.w / before.w * 100
    h.fk = (pow 2, questionLeft) / (combinatoric.denominator questionLeft, maxLies)
    balasB = combinatoric.berlekamp balasN, questionLeft, maxLies
    balasP = round balasB / before.w * 100 
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
    {set, playing, range, maxLies, qx, q} = @state

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
              if h.c
                dom 'small', {},
                  dom 'i', {}, ' '
                  dom 'span',
                    className: "color-br-0"
                    "[#{h.c[1].toString()}]:(#{h.wy} #{h.wpy}%)"
                  dom 'i', {}, ' '
                  dom 'span',
                    className: "color-br-#{lieLimit}"
                    "[#{h.c[0].toString()}]:(#{h.wn} #{h.wpn}%)"

module.exports = Subset