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

module.exports = new Combinatoric