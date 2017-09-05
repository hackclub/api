import React, { Component } from 'react'
import Radium from 'radium'

import colors from '../../styles/colors'

const styles = {
  color: colors.gray,
  fontStyle: 'italic',
}

class Subtitle extends Component {
  render() {
    return (
      <p {...this.props} style={[styles,this.props.style]}>{this.props.children}</p>
    )
  }
}

export default Radium(Subtitle)
