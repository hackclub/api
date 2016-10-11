import React, { Component } from 'react'
import { Router, Route, Link, browserHistory } from 'react-router'
import Intake from './Intake'
import NoMatch from './NoMatch'

class Routes extends Component {
  render() {
    return (
      <Router history={browserHistory}>
        <Route path="/intake" component={Intake} />
        <Route path="*" component={NoMatch} />
      </Router>
    )
  }
}

export default Routes
