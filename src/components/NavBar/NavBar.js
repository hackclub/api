import React, { Component } from 'react'
import Radium from 'radium'
import colors from '../../styles/colors'

import Logo from './Logo'

const styles = {
  wrapper: {
    backgroundColor: colors.primary,
    height: '60px'
  }
}

class NavBar extends Component {
  render() {
    return (
      <div style={[styles.wrapper,this.props.style]}>
        <Logo />
      </div>
    )
  }
}

export default Radium(NavBar)
