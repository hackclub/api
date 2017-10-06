import React from 'react'
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

const ExportButtons = Radium(props => {
  const { titleizedName } = props
  const pdfOptions = {
    filename: `${titleizedName || 'Workshop'}.pdf`,
    margin: 10,
    html2canvas: {
      useCORS: true,
      image: { type: 'png' },
      dpi: 192
    }
  }

  return (
    <div style={styles.spacer}>
      <div style={styles.wrapper}>
        <Button
          style={styles.topButton}
          type="link"
          onClick={() =>
            window.html2pdf(
              document.querySelector('.markdown-body'),
              pdfOptions
            )}
        >
          Download
        </Button>
        <Button type="link" onClick={window.print}>
          Print
        </Button>
      </div>
    </div>
  )
})

export default ExportButtons
