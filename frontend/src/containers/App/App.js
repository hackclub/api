import React, { Component } from 'react'

const styles = {
  height: '100%',
  fontFamily: "'Open Sans', sans-serif"
}

class App extends Component {
  render() {
    return (
      <div style={styles}>
        {this.props.children}
      </div>
    )
  }
}

export default App
