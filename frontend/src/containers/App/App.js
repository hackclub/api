import React, { Component } from 'react'
import Helmet from 'react-helmet'
import config from '../../config'

const styles = {
  minHeight: '100%',
  fontFamily: "'Open Sans', sans-serif"
}

class App extends Component {
  render() {
    return (
      <div style={styles}>
        <Helmet {...config.app.head} />
        {this.props.children}
      </div>
    )
  }
}

export default App
