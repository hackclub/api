import React, { Component } from 'react'
import Radium from 'radium'

import logo from './logo.svg'

const styles = {
  wrapper: {
    display: 'inline-block',
    height: '100%',
    paddingLeft: '20px',
    paddingRight: '20px'
  },
  // See https://stackoverflow.com/a/7310398 for how this helper works.
  verticalAlignHelper: {
    display: 'inline-block',
    height: '100%',
    verticalAlign: 'middle'
  },
  image: {
    verticalAlign: 'middle',
    height: '40%'
  }
}

class Logo extends Component {
  render() {
    return (
      <div style={[styles.wrapper,this.props.style]}>
        <span style={styles.verticalAlignHelper} />
        <img src={logo} alt="Hack Club logo" style={styles.image} />
      </div>
    )
  }
}

export default Radium(Logo)
