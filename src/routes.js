import React from 'react'
import { Route } from 'react-router'
import {
  App,
  NotFound
} from './containers'

import './cssReset.css'
import './index.css'

export default (store) => {
  return (
    <Route path="/" component={App}>
      <Route path="*" component={NotFound} status={404} />
    </Route>
  )
}
