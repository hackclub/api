import React from 'react'
import Helmet from 'react-helmet'
import config from 'config'

const styles = {
  height: '100%',
  fontFamily: "'Open Sans', -apple-system, BlinkMacSystemFont, 'Avenir Next', 'Helvetica Neue', Roboto, 'Segoe UI', sans-serif"
}

const App = (props) => {
  return (
    <div style={styles}>
      <Helmet {...config.head} />
      {props.children}
    </div>
  )
}

export default App
