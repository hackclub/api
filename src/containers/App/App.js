import React, { Component } from 'react'
import Helmet from 'react-helmet'
import config from '../../config'

class App extends Component {
  render() {
    return (
      <div>
        <Helmet {...config.app.head} />
        {this.props.children}
      </div>
    )
  }
}

export default App
