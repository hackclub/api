import React, { Component } from 'react'
import { Router, Route, Link, browserHistory } from 'react-router'
import Intake from './Intake'
import NotFound from './NotFound'

class Routes extends Component {
  render() {
    return (
      <Router history={browserHistory}>
        <Route path="/intake" component={Intake} />
        <Route path="*" component={NotFound} />
      </Router>
    )
  }
}

export default Routes
