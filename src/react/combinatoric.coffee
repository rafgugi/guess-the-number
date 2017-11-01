class Combinatoric
  p: (m, n) ->
    p = 1
    while n--
      p *= m--
    return p

  c: (m, n) ->
    if n > m then return 0
    else if n > m / 2 then return @c(m, m - n)
    else return @p(m, n) / @p(n, n)

  denominator: (m, n) ->
    p = 0
    for i in [0...n] by 1
      p += @c(m, i)
    return p

  # hitung berlekamp weight
  #
  # @param state vector
  # @param berapa pertanyaan lagi yang boleh diajukan
  # @param jumlah maksimal bohong
  berlekamp: (vector, questionLeft, maxLies) ->
    weight = 0
    for x, i in vector by 1
      weight += x * @denominator(questionLeft, maxLies - i)
    return weight

window.combinatoric = new Combinatoric
module.exports = window.combinatoric