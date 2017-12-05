import React from 'react'
import Radium from 'radium'
import colors from 'styles/colors'

const styles = {
  marginBottom: '16px',
  fontSize: '18px',
  lineHeight: '27px',
  color: colors.text
}
const Text = props => {
  return <p style={[styles, props.style]}>{props.children}</p>
}

export default Radium(Text)
