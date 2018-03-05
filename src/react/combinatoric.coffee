class Combinatoric

  # permutator
  p: (m, n) ->
    p = 1
    while n--
      p *= m--
    return p

  # combinator
  c: (m, n) ->
    if n > m then return 0
    else if n > m / 2 then return @c(m, m - n)
    else return @p(m, n) / @p(n, n)

  denominator: (q, k) ->
    p = 0
    for i in [0...k] by 1
      p += @c(q, i)
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

  ch: (vector, maxLies) ->
    q = 0
    b = 0
    p = 0
    while (b = @berlekamp(vector, q, maxLies)) > (p = Math.pow(2, q))
      q++
      console.log q, b, p, b > p

window.combinatoric = new Combinatoric
module.exports = window.combinatoric