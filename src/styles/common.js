function buildMediaQuery(lowerBound) {
  return `@media only screen and (min-width:${lowerBound})`
}

export const mediaQueries = {
  smallUp: buildMediaQuery("0px"),
  mediumUp: buildMediaQuery("640px"),
  largeUp: buildMediaQuery("1024px"),
  extraLargeUp: buildMediaQuery("1440px"),
  extraExtraLargeUp: buildMediaQuery("1920px")
}

export default {
  ...mediaQueries
}
