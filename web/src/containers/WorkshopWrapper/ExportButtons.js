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
  componentDidUpdate(_, previousState) {
    if (!previousState.downloadState && this.state.downloadState === 'loading') {
      this.downloadPdf()
    }
  }

  downloadPdf() {
    const { titleizedName } = this.props
    const pdfOptions = {
      filename: `${titleizedName || 'Workshop'}.pdf`,
      margin: 10,
      html2canvas: {
        useCORS: true,
        image: { type: 'png' },
        dpi: 192
      }
    }

    window.html2pdf(document.querySelector('.markdown-body'), pdfOptions)

    setTimeout(() => {
      this.setState({ downloadState: null })
    }, 6000)
  }

  render() {
    const { downloadState } = this.state

    return (
      <div style={styles.spacer}>
        <div style={styles.wrapper}>
          <Button
            state={downloadState}
            style={styles.topButton}
            type="form"
            onClick={() => this.setState({ downloadState: 'loading' })}
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
