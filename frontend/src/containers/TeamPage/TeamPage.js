import React, { Component } from 'react'
import Helmet from 'react-helmet'

import { NavBar } from '../../components'

const styles = {
  iframe: {
    width: '100%',
  }
}

class TeamPage extends Component {
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
    return(
      <div>
        <Helmet title="Team" />
        <NavBar />

        <iframe ref="iframe" style={styles.iframe} src="/staticPage/team/index.html" />
      </div>
    )
  }
}

export default TeamPage
