const colors = {
  red: '#e42d40',
  white: '#ffffff',
  veryLightGray: '#ededed',
  lightGray: '#cccccc',
  gray: '#888888',
  darkGray: '#575757'
}

const brandPreferences = {
  primary: colors.red,
  bg: colors.white,

  outline: colors.lightGray,
  placeholder: colors.veryLightGray,
  userInput: colors.darkGray
}

export default {
  ...colors,
  ...brandPreferences
}
