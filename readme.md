## Guess the number

### How do I get set up?

- Ensure you have [Node.js](https://nodejs.org/en/), [npm](https://www.npmjs.com/), [bower](https://bower.io/), and [gulp](http://gulpjs.com/)
- Run `npm install`
- Run `bower install`
- Run `npm start`
- Open `index.html` in browser

### What to do with this app?

Judge has chosen a number x in the range [1, n]. Guesser has to find the number x using query
range [a, b], then Judge has to answer if the number is inside range [a, b].

Firstly, define the range from 1 to n, then press start button. You can always restart the game
by pressing restart button. Then each turn, Guesser give a query range [a, b], Judge then answer
the query whether the number is inside range [a, b] given by Guesser.

Judge is allowed to lie w times in single game. Program will memorize all queries and answers to
ensure Judge doesn't lie more than w times