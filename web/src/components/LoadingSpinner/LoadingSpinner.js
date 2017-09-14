import React, { Component } from 'react'
import Radium from 'radium'
import { Emoji, Text } from 'components'

const rotateKeyframes = Radium.keyframes({
  '0%': {transform: 'rotate(0deg)'},
  '100%': {transform: 'rotate(359deg)'},
}, 'linear')

const styles = {
  emoji: {
    width: '2em',
    height: '2em'
  },
  wrapper: {
    textAlign: 'center',
    width: '100%',
    height: '100%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  },
  spinner: {
    display: 'inline-block',
    transformOrigin: '50% 17%',
    animationName: rotateKeyframes,
    animationDuration: '1.25s',
    animationTimingFunction: 'linear',
    animationIterationCount: 'infinite',
  }
}

class LoadingSpinner extends Component {
  render() {
    return(
      <div style={styles.wrapper}>
        <div style={styles.spinner}>
          <Emoji type="thinking_face" style={styles.emoji}/>
          <Text>Loading...</Text>
        </div>
      </div>
    )
  }
}

export default Radium(LoadingSpinner)
