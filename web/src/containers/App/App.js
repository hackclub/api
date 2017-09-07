import React, { Component } from 'react'
import Helmet from 'react-helmet'
import config from '../../config'

const styles = {
  height: '100%',
  fontFamily: "'Open Sans', -apple-system, BlinkMacSystemFont, 'Avenir Next', 'Helvetica Neue', Roboto, 'Segoe UI', sans-serif"
}

class App extends Component {
  render() {
    return (
      <div style={styles}>
        <Helmet {...config.head} />
        {this.props.children}
      </div>
    )
  }
}

export default App
