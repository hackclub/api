import color from 'color'

const colors = {
  red: '#e42d40',
  yellow: '#fbc125',
  green: '#40bf20',
  brightGreen: '#17d222',
  blue: '#2196f3',
  white: '#ffffff',
  veryLightGray: '#ededed',
  lightGray: '#c0c0c0',
  gray: '#888888',
  darkGray: '#575757',
  offBlack: '#4a4a4a',
  black: '#383838'
}

const brandPreferences = {
  primary: colors.red,
  fadedPrimary: color(colors.red).darken(0.5).hexString(),

  warning: colors.yellow,
  success: colors.green,

  bg: colors.white,
  text: colors.black,

  outline: colors.lightGray,
  placeholder: colors.veryLightGray,
  userInput: colors.darkGray,

  disabled: colors.lightGray,

  offBrandEmphasis: colors.blue,
  offBrandSecondaryEmphasis: colors.brightGreen
}

export default {
  ...colors,
  ...brandPreferences
}
