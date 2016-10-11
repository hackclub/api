import React from 'react'
import ReactDOM from 'react-dom'
import createStore from './redux/create'
import ApiClient from './helpers/ApiClient'
import { Provider } from 'react-redux'
import { Router, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import getRoutes from './routes'

const client = new ApiClient()
const store = createStore(browserHistory, client, window.__data)
const history = syncHistoryWithStore(browserHistory, store)

const component = (
  <Router history={history}>
    {getRoutes(store)}
  </Router>
)

ReactDOM.render(
  <Provider store={store} key="provider">
    {component}
  </Provider>,
  document.getElementById('root')
)
