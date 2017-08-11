import React from 'react'
import ReactDOM from 'react-dom'
import ReactGA from 'react-ga'
import createStore from './redux/create'
import ApiClient from './helpers/ApiClient'
import { Provider } from 'react-redux'
import { Router, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'
import { StyleRoot } from 'radium'
import config from './config'

import getRoutes from './routes'

const client = new ApiClient()
const store = createStore(browserHistory, client, window.__data)
const history = syncHistoryWithStore(browserHistory, store)

const component = (
  <Router history={history} onUpdate={logPageView}>
    {getRoutes(store)}
  </Router>
)

const styleRootStyles = {
  height: '100%',
  width: '100%'
}

ReactGA.initialize(config.googleAnalyticsId)

function logPageView() {
  ReactGA.set({ page: window.location.pathname + window.location.search })
  ReactGA.pageview(window.location.pathname + window.location.search)
}

ReactDOM.render(
  <Provider store={store} key="provider">
    <StyleRoot style={styleRootStyles}>
      {component}
    </StyleRoot>
  </Provider>,
  document.getElementById('root')
)
