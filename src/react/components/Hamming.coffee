React = require 'react'
createReactClass = require 'create-react-class'
combinatoric = require '../combinatoric'
dom = React.createElement

{abs, min, max, log2, ceil, round, pow} = Math
lieLimit = 16 # limitation of lie by the program

Hamming = createReactClass
  displayName: 'Hamming'

  getInitialState: ->
    codewords: []
    distanceMatrix: []
    playing: false
    q: ''

    # input values
    range: 8
    maxLies: 4 # maximal number of lies

  componentWillMount: ->
    @setState
      codewords: []
      distanceMatrix: []
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
      codewords: []

  # handleUndoButton: ->
  #   {set} = @state
  #   if set.length > 1
  #     questionLeft++
  #     last = (set.splice -1, 1)[0]
  #     {q, qx} = last
  #     @setState {set, q, qx}

  handlePlayButton: ->
    {range, maxLies} = @state
    if range isnt '' && maxLies isnt ''
      playing = true
      maxLies = min lieLimit, max 0, maxLies
      codewords = []
      distanceMatrix = []

      for i in [0...range] by 1
        codewords[i] = ''
        distanceMatrix[i] = []
        for j in [i+1...range] by 1
          distanceMatrix[i][j] = 0

      @setState {playing, maxLies, codewords, distanceMatrix}

  handleSubmitButton: ->
    {codewords, distanceMatrix, maxLies, q, range} = @state
    if not @queryValidator q, range
      return
    queries = q.split '\n'

    for query in queries
      for i in [0...range] by 1
        codewords[i] += "" + query[i]
        for j in [i+1...range] by 1
          ans = query[i] isnt query[j]
          distanceMatrix[i][j] += ans
    @setState
      codewords: codewords
      distanceMatrix: distanceMatrix

  queryValidator: (q, range) ->
    queries = q.split '\n'
    for query in queries
      if query.length isnt range
        console.log "query harus berjumlah #{range} (#{query.length})"
        return false
    return true

  render: ->
    {codewords, distanceMatrix, playing, range, maxLies, q} = @state

    dom 'section', className: 'row',
      dom 'span', className: 'five columns',
        # Initial game
        dom 'div', className: 'row',
          dom 'div', className: 'four columns',
            dom 'label', {}, 'Codewords count'
            dom 'input',
              type: 'text'
              className: 'u-full-width'
              name: 'range'
              onChange: @handleInputNumberChange
              value: range
              disabled: playing
          dom 'div', className: 'two columns',
            dom 'label', {}, 'Errors'
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
          dom 'div', className: 'twelve columns',
            dom 'label', {}, 'Query'
            dom 'textarea',
              # type: 'text'
              className: 'u-full-width'
              name: 'q'
              onChange: @handleInputChange
              value: q

          # Buttons
          dom 'div', className: 'nine columns',
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
          dom 'span', {}, "Binary bitstrings are string with length n, each digit
            only filled by 0 and 1."
          dom 'br'
          dom 'span', {}, "Binary code (n,M,d)2 is M bitstrings (called codeword)
            with length n, in which every different codewords have minimal Hamming
            distance d."
          dom 'br'
          dom 'span', {}, "Hamming distance between bitstrings x and y is number
            of coordinates i where xi≠yi. Example dH(000,011) = 2 and
            dH(00010,01101) = 4."
          dom 'br'
          dom 'small', {}, "This program is a simulation to construct a binary code
            with given M and d. Your task is adding a digit for each codewords
            vertically to increase distance between each codewords."

      # History of truth and lies codewords
      if playing
        dom 'span', className: 'seven columns question-bar',
          dom 'label', {}, 'Codewords'
          dom 'div', className: 'scrollx',
            dom 'table', className: 'table no-padding',
              for code, i in codewords
                dom 'tr', key: i,
                  dom 'td', {}, "#{i+1}: "
                  dom 'td'
                  dom 'td'
                  dom 'td', {}, dom 'samp', {}, code
          dom 'br'
          dom 'label', {}, 'Distance matrix'
          dom 'div', className: 'scrollx',
            dom 'table', className: 'table',
              dom 'tr', {},
                dom 'td', {}, ''
                for i in [0...range] by 1
                  dom 'td', key: i, i + 1
              for dist, i in distanceMatrix
                dom 'tr', key: i,
                  dom 'td', {}, i + 1
                  for d, j in dist
                    if i is j
                      dom 'td', key: j, 'X'
                    else
                      dom 'td', key: j, d

module.exports = Hamming