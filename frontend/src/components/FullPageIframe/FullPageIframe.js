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
    var iframe = this.refs.iframe

    window.addEventListener('resize', () => {
      var iframeScrollHeight = iframe.contentWindow.document.body.scrollHeight + 'px'

      iframe.height = iframeScrollHeight
    })

    iframe.addEventListener('load', () => {
      var iframeScrollHeight = iframe.contentWindow.document.body.scrollHeight + 'px'

      iframe.height = iframeScrollHeight
    })
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
