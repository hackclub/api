import React, { Component } from 'react'
import Radium from 'radium'
import { Button } from 'components'
import mediaQueries from 'styles/common'

const styles = {
  spacer: {
    height: '5em'
  },
  wrapper: {
    [mediaQueries.smallUp]: {
      display: 'none'
    },
    [mediaQueries.print]: {
      display: 'none'
    },
    [mediaQueries.mediumUp]: {
      display: 'initial',
      position: 'fixed',
      bottom: '1em',
      right: '1em'
    }
  },
  topButton: {
    marginBottom: '0.5em'
  }
}

class ExportButtons extends Component {
  render() {
    const { pdfDownloadHref, titleizedName } = this.props
    return (
      <div style={styles.spacer}>
        <div style={styles.wrapper}>
          <Button
            style={styles.topButton}
            type="link"
            href={pdfDownloadHref}
            download={`${titleizedName}.pdf`}
          >
            Download
          </Button>
          <Button type="link" onClick={window.print}>
            Print
          </Button>
        </div>
      </div>
    )
  }
}

export default Radium(ExportButtons)
