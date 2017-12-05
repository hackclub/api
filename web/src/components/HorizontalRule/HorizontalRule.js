import React from 'react'
import Radium from 'radium'
import colors from 'styles/colors'
import { mediaQueries } from 'styles/common'

const styles = {
  border: 'none',
  backgroundColor: colors.gray,
  height: '4px',
  [mediaQueries.mediumUp]: {
    height: '5px'
  }
}

const HorizontalRule = props => {
  return <hr style={[styles, props.style]} />
}

export default Radium(HorizontalRule)
