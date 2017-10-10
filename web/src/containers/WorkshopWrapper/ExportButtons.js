import React, { Component } from 'react'
import Radium from 'radium'
import { Button } from 'components'
import mediaQueries from 'styles/common'

const styles = {
  spacer: {
    height: '5em'
  },
  wrapper: {
    [mediaQueries.print]: {
      display: 'none'
    },
    bottom: '1em',
    [mediaQueries.mediumUp]: {
      position: 'fixed',
      right: '1em'
    }
  },
  button: {
    [mediaQueries.smallUp]: {
      marginBottom: '0.5em'
    },
    paddingLeft: '15px',
    paddingRight: '15px'
  },
  topButton: {
    marginTop: '0.5em'
  }
}

class ExportButtons extends Component {
  render() {
    const { pdfDownloadHref, titleizedName } = this.props
    return (
      <div style={styles.spacer}>
        <div style={styles.wrapper}>
          <Button
            style={[styles.button, styles.topButton]}
            type="link"
            href={pdfDownloadHref}
            download={`${titleizedName}.pdf`}
          >
            Download as PDF
          </Button>
          <Button type="link" style={styles.button} onClick={window.print}>
            Print
          </Button>
        </div>
      </div>
    )
  }
}

export default Radium(ExportButtons)
