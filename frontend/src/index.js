import React from 'react'
import ReactDOM from 'react-dom'
import createStore from './redux/create'
import ApiClient from './helpers/ApiClient'
import Raven from 'raven-js'
import { Provider } from 'react-redux'
import { Router, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'
import { StyleRoot } from 'radium'

import getRoutes from './routes'

const client = new ApiClient()
const store = createStore(browserHistory, client, window.__data)
const history = syncHistoryWithStore(browserHistory, store)

const component = (
  <Router history={history}>
    {getRoutes(store)}
  </Router>
)

const styleRootStyles = {
  height: '100%',
  width: '100%'
}

Raven.config(process.env.REACT_APP_SENTRY_DSN).install()

ReactDOM.render(
  <Provider store={store} key="provider">
    <StyleRoot style={styleRootStyles}>
      {component}
    </StyleRoot>
  </Provider>,
  document.getElementById('root')
)
