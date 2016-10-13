import React, { Component } from 'react'
import Helmet from 'react-helmet'
import config from '../../config'

const styles = {
  height: '100%'
}

class App extends Component {
  render() {
    if (!this.props.children) {
      window.location = "https://hackclub.com"
    }

    return (
      <div style={styles}>
        <Helmet {...config.app.head} />
        {this.props.children}
      </div>
    )
  }
}

export default App
