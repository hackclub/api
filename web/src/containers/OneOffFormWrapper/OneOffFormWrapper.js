import React, { Component } from 'react'
import Radium from 'radium'
import pattern from 'styles/pattern.png'

const styles = {
  height: '100%',
  minWidth: '100%',
  backgroundImage: `url(${pattern})`,
  backgroundSize: '450px'
}

const OneOffFormWrapper = props => {
  return <div style={styles}>{props.children}</div>
}

export default Radium(OneOffFormWrapper)
