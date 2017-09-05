import React, { Component } from 'react'
import Helmet from 'react-helmet'

import { NavBar } from '../../components'

const styles = {
  iframe: {
    width: '100%',
  }
}

class FullPageIframe extends Component {
  componentDidMount() {
    const iframe = this.refs.iframe

    const resizeFrame = () => {
      const iframeScrollHeight = iframe.contentWindow.document.body.scrollHeight + 'px'

      iframe.style.height = iframeScrollHeight
    }

    iframe.addEventListener('resize', resizeFrame)
    iframe.addEventListener('load', resizeFrame)
  }

  render() {
    const { src, title } = this.props

    return (
      <div>
        <Helmet title={title} />
        <NavBar />

        <iframe ref="iframe" style={styles.iframe} title={title} src={src} />
      </div>
    )
  }
}

export default FullPageIframe
