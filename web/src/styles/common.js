const mq = lowerBound => `@media only screen and (min-width: ${lowerBound}em)`

export const mediaQueries = {
  smallUp: mq(0),
  mediumUp: mq(52),
  largeUp: mq(64),
  extraLargeUp: mq(90),
  extraExtraLargeUp: mq(120),
  print: '@media print'
}

export default {
  ...mediaQueries
}
