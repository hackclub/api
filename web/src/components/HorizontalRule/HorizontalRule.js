import React, { Component } from 'react'
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

class HorizontalRule extends Component {
  render() {
    return <hr style={[styles, this.props.style]} />
  }
}

export default Radium(HorizontalRule)
