import React from 'react'
import Radium from 'radium'
import { mediaQueries } from 'styles/common'

const styles = {
  marginLeft: 'auto',
  marginRight: 'auto',
  width: '90%',
  [mediaQueries.largeUp]: {
    width: '900px'
  }
}

const Container = props => {
  return <div style={[styles, props.style]}>{props.children}</div>
}

export default Radium(Container)
