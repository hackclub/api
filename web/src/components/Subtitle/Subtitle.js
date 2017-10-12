import React from 'react'
import Radium from 'radium'

import colors from 'styles/colors'

const styles = {
  color: colors.gray,
  lineHeight: '140%',
  fontStyle: 'italic'
}

const Subtitle = props => {
  return (
    <p {...props} style={[styles, props.style]}>
      {props.children}
    </p>
  )
}

export default Radium(Subtitle)
