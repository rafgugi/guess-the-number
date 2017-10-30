React = require 'react'
createReactClass = require 'create-react-class'
combinatoric = require '../combinatoric'
dom = React.createElement

{abs, min, max, log2, ceil, round} = Math
[Yes, No] = ['Yes', 'No']
lieLimit = 16 # limitation of lie by the program

Subset = createReactClass
  displayName: 'Subset'

  getInitialState: ->
    set: [] # truth set and lie set
    playing: false
    questionLeft: 0

    # input values
    range: 64
    maxLies: 4 # maximal number of lies
    qx: Yes # query answer

    hasError: [] # inputs that have error

  componentWillMount: ->
    # only for debugging
    @handlePlayButton()
    @setState
      set: [{"q":[0,0,0,0,0],"n":[64,0,0,0,0],"w":1682560},{"n":[32,32,0,0,0],"q":[32,0,0,0,0],"c":{"Yes":[32,32,0,0,0],"No":[32,32,0,0,0]},"w":888832,"wy":888832,"wn":888832},{"n":[16,32,16,0,0],"q":[16,16,0,0,0],"c":{"Yes":[16,32,16,0,0],"No":[16,32,16,0,0]},"w":444416,"wy":444416,"wn":444416},{"n":[8,24,24,8,0],"q":[8,16,8,0,0],"c":{"Yes":[8,24,24,8,0],"No":[8,24,24,8,0]},"w":222208,"wy":222208,"wn":222208},{"n":[4,16,24,16,4],"q":[4,12,12,4,0],"c":{"Yes":[4,16,24,16,4],"No":[4,16,24,16,4]},"w":111104,"wy":111104,"wn":111104},{"n":[2,10,20,20,10],"q":[2,8,12,8,2],"c":{"Yes":[2,10,20,20,10],"No":[2,10,20,20,10]},"w":55552,"wy":55552,"wn":55552}]

  componentDidMount: ->
    @handleResetButton()

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
    set = @state.set
    if set.length > 1
      last = set.splice -1, 1
      @setState {set}
      @setQueryInput last[0].q

  handlePlayButton: ->
    {range, maxLies} = @state
    if range isnt '' && maxLies isnt ''
      playing = true
      maxLies = min lieLimit, max 0, maxLies
      questionLeft = (ceil log2 range) * (maxLies * 2 + 1)
      q = (0 for i in [0..maxLies]) # query
      n = [range].concat(0 for i in [0..maxLies - 1]) # state
      w = combinatoric.berlekamp n, questionLeft, maxLies # berlekamp
      wp = 100
      set = [{q, n, w, wp}]
      @setQueryInput n

      @setState {playing, maxLies, questionLeft, set}

  handleSubmitButton: ->
    if not @queryValidator()
      return
    {set, questionLeft, maxLies} = @state
    h = @generateHistory()
    @setQueryInput h.n
    set.push(h)
    console.log 'set', set, JSON.stringify set

    @setState
      set: set
      questionLeft: questionLeft - 1

  # Set query input to an array given
  # @param Array | null
  setQueryInput: (input = null) ->
    if input is null
      input = @state.set[@state.set.length - 1].n
    stateInput = []
    for val, i in input
      stateInput["q#{i}"] = val
    @setState stateInput

  handleResetButton: ->
    @setQueryInput()

  queryValidator: ->
    {qx, maxLies, set} = @state
    if qx is '' then return false
    last = set[set.length - 1]
    hasError = []
    for i in [0..maxLies]
      if @state["q#{i}"] > last.n[i]
        hasError.push i
    @setState {hasError}
    return hasError.length <= 0

  generateHistory: ->
    {set, qx, maxLies, questionLeft} = @state
    lastSet = set[set.length - 1]
    last = lastSet.n
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
    h.w = combinatoric.berlekamp n, questionLeft, maxLies
    h.wy = combinatoric.berlekamp c[Yes], questionLeft, maxLies
    h.wn = combinatoric.berlekamp c[No], questionLeft, maxLies
    h.wp = round h.w / lastSet.w * 100
    h.wpy = round h.wy / lastSet.w * 100
    h.wpn = round h.wn / lastSet.w * 100
    h

  render: ->
    {set, playing, range, maxLies, qx, questionLeft, hasError} = @state

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
                onClick: @handleRestartButton
                'Restart'

        # Query game
        dom 'div',
          className: "#{'u-hide' if not playing}"
          dom 'hr'

          # Subset query
          dom 'div', className: 'row',
            for i in [0..maxLies]
              dom 'div',
                key: i
                className: "two columns"
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

          dom 'div', {},
            dom 'button',
              type: 'button'
              className: 'button'
              onClick: @handleResetButton
              'Reset'
            dom 'i', {}, ' '
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
      dom 'span', className: 'six columns',
        dom 'label', {}, 'Question bar'
        if not playing
          # Example
          dom 'div', className: 'history',
            # Query
            dom 'span', {},
              dom 'span',
                className: "set bg-color-br-0-muted",
                title: 'Lie channel and amount query asked'
                "<amount_query>"
              dom 'i', {}, ' '
              dom 'span',
                className: "set bg-color-br-#{lieLimit}-muted",
                title: 'Lie channel and amount query asked'
                "<amount_query>"
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
                "[ lie_ch_yes_count ]:(<yes_berlekamp_weight> <yes_per_total_percent>%)"
              dom 'br'
              dom 'span',
                className: "color-br-#{lieLimit}"
                title: 'Channel if answer is no'
                "[ lie_ch_no_count ]:(<no_berlekamp_weight> <no_per_total_percent>%)"
        else
          for h, i in set
            dom 'div', key: i, className: 'history',
              # Query
              dom 'span', {},
                for val, j in h.q
                  dom 'span', key: j,
                    dom 'span',
                      className: "set bg-color-br-#{ceil(j * lieLimit / maxLies)}-muted",
                      "#{val}"
                    dom 'i', {}, ' '
              # Channel
              dom 'small', {}, "[#{h.n.toString()}]:(#{h.w} #{h.wp}%)"
              if h.c
                dom 'small', {},
                  dom 'i', {}, ' '
                  dom 'span',
                    className: "color-br-0"
                    "[#{h.c[Yes].toString()}]:(#{h.wy} #{h.wpy}%)"
                  dom 'i', {}, ' '
                  dom 'span',
                    className: "color-br-#{lieLimit}"
                    "[#{h.c[No].toString()}]:(#{h.wn} #{h.wpn}%)"

module.exports = Subset