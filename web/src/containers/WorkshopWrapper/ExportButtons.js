import React, { Component } from 'react'
import Radium from 'radium'
import { Button } from '../../components'
import mediaQueries from '../../styles/common.js'

const styles = {
  spacer: {
    height: '5em'
  },
  wrapper: {
    [mediaQueries.smallUp]: {
      display: 'none',
    },
    [mediaQueries.print]: {
      display: 'none',
    },
    [mediaQueries.mediumUp]: {
      display: 'initial',
      position: 'fixed',
      bottom: '1em',
      right: '1em',
    }
  }
}

class ExportButtons extends Component {
  render() {
    return (
      <div style={styles.spacer}>
        <div style={styles.wrapper}>
          <Button type="link" href="javascript:window.print()">Print this page</Button>
        </div>
      </div>
    )
  }
}

export default Radium(ExportButtons)
