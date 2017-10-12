import React from 'react'
import Radium from 'radium'
import colors from 'styles/colors'

const styles = {
  backgroundColor: colors.bg,
  maxWidth: '350px',
  padding: '17.5px',
  border: `1px solid ${colors.outline}`,
  boxShadow: `0px 1px 50px -15px ${colors.gray}`,
  borderRadius: '5px'
}

const Card = props => {
  return <div style={[styles, props.style]}>{props.children}</div>
}

export default Radium(Card)
