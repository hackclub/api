import React, { Component } from 'react'
import Radium from 'radium'

import arrow from './arrow.svg'

const styles = {
  verticalAlign: 'middle',
  width: '45px'
}

class Arrow extends Component {
  render() {
    return (
      <img src={arrow} alt="Arrow" style={[styles,this.props.style]} />
    )
  }
}

export default Radium(Arrow)
