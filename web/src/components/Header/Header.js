import React from 'react'
import Radium from 'radium'
import colors from 'styles/colors'

const styles = {
  backgroundColor: colors.primary,
  color: colors.bg,

  textAlign: 'center',
  padding: '40px'
}

const Header = props => {
  return <div style={[styles, props.style]}>{props.children}</div>
}

export default Radium(Header)
