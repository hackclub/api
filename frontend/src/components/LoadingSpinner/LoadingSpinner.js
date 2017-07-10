import React, { Component } from 'react'
import Radium from 'radium'
import { Emoji, Text } from '../../components'

const rotateKeyframes = Radium.keyframes({
  '0%': {transform: 'rotate(0deg)'},
  '100%': {transform: 'rotate(359deg)'},
}, 'linear')

const styles = {
  textAlign: 'center',
  margin: '0 auto',
  animationName: rotateKeyframes,
  animationDuration: '1s',
  animationTimingFunction: 'linear',
  animationIterationCount: 'infinite',
}

class LoadingSpinner extends Component {
  render() {
    return(
      <div style={styles}>
        <Emoji type="thinking_face" />
        <Text>Loading...</Text>
      </div>
    )
  }
}

export default Radium(LoadingSpinner)
