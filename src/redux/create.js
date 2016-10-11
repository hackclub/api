import { createStore as _createStore, applyMiddleware } from 'redux'
import createMiddleware from './middleware/clientMiddleware'
import { routerMiddleware } from 'react-router-redux'
import reducer from './modules/reducer'

export default function createStore(history, client, data) {
  // Sync dispatched route actions to the history
  const reduxRouterMiddleware = routerMiddleware(history)

  const middleware = [createMiddleware(client), reduxRouterMiddleware]

  let finalCreateStore = applyMiddleware(...middleware)(_createStore)

  return finalCreateStore(reducer, data)
}
