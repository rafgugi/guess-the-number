class Combinatoric
  p: (m, n) ->
    p = 1
    while (n--)
      p *= m--
    p

  c: (m, n) ->
    if n > m then 0
    else if n > m / 2 then @c(m, m - n) # minimize computation
    else @p(m, n) / @p(n, n)

  denominator: (m, n) ->
    p = 0
    for i in [0...n]
      p += @c(m, i)
    p

  # hitung berlekamp weight
  #
  # @param state vector
  # @param berapa pertanyaan lagi yang boleh diajukan
  # @param jumlah maksimal bohong
  berlekamp: (vector, questionLeft, maxLies) ->
    weight = 0
    for x, i in vector
      weight += x * @denominator(questionLeft, maxLies - i)
    weight

module.exports = new Combinatoric