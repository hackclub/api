import React from 'react'
import Radium from 'radium'
import { Emoji, Text } from 'components'

const rotateKeyframes = Radium.keyframes(
  {
    '0%': { transform: 'rotate(0deg)' },
    '100%': { transform: 'rotate(359deg)' }
  },
  'linear'
)

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
    flexDirection: 'column',
    justifyContent: 'center'
  },
  spinner: {
    display: 'inline-block',
    transformOrigin: '50% 17%',
    animationName: rotateKeyframes,
    animationDuration: '1.25s',
    animationTimingFunction: 'linear',
    animationIterationCount: 'infinite'
  }
}

const LoadingSpinner = props => {
  return (
    <div style={[styles.wrapper, props.style]}>
      <div style={styles.spinner}>
        <Emoji type="thinking_face" style={styles.emoji} />
        <Text>Loading...</Text>
      </div>
      {props.children}
    </div>
  )
}

export default Radium(LoadingSpinner)
