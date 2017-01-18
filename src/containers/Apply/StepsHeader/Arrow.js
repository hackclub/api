import React, { Component } from 'react'
import Radium from 'radium'
import { mediaQueries } from '../../../styles/common'

import arrow from './arrow.svg'

const styles = {
  verticalAlign: 'middle',
  width: '25px',
  [mediaQueries.mediumUp]: {
    width: '45px'
  }
}

class Arrow extends Component {
  render() {
    return (
      <img src={arrow} alt="Arrow" style={[styles,this.props.style]} />
    )
  }
}

export default Radium(Arrow)
