import React, { Component } from 'react'
import Radium from 'radium'
/* import html2pdf from './html2pdf'*/
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
  }
}

class PrintButton extends Component {
  render() {
    const { filename } = this.props

    return (
      <div style={styles.spacer}>
        <div style={styles.wrapper}>
          <Button type="link" onClick={() => window.html2pdf(document.querySelector('.markdown-body'), {
              filename: `${filename || 'workshop'}.pdf`,
              margin: 10,
              html2canvas: {
                useCORS: true,
                image: { type: 'png' },
                dpi: 192
              }
              })}>
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

export default Radium(PrintButton)
