import React from 'react'
import { Route } from 'react-router'
import {
  App,
  Cloud9Setup,
  HackbotNewTeam,
  LeaderIntake,
  NotFound,
} from './containers'

import './cssReset.css'
import './index.css'

export default (store) => {
  return (
    <Route path="/" component={App}>
      <Route path="cloud9_setup" component={Cloud9Setup} />
      <Route path="intake" component={LeaderIntake} />
      <Route path="hackbot/teams/new" component={HackbotNewTeam} />

      <Route path="*" component={NotFound} status={404} />
    </Route>
  )
}
