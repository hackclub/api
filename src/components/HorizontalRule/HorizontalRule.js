import React, { Component } from 'react'
import Radium from 'radium'
import colors from '../../styles/colors'

const styles = {
  border: 'none',
  backgroundColor: colors.gray,
  height: '5px'
}

class HorizontalRule extends Component {
  render() {
    return (
      <hr style={[styles,this.props.style]} />
    )
  }
}

export default Radium(HorizontalRule)
