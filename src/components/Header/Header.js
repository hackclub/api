import React, { Component } from 'react'
import Radium from 'radium'
import colors from '../../colors'

const styles = {
  backgroundColor: colors.primary,
  color: colors.bg,

  textAlign: 'center',
  padding: '40px'
}

class Header extends Component {
  render() {
    return (
      <div style={[styles, this.props.style]}>
        {this.props.children}
      </div>
    )
  }
}

export default Radium(Header)
