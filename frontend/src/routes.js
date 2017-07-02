import React from 'react'
import { Route } from 'react-router'
import {
  App,
  Cloud9Setup,
  HackbotNewTeam,
  LeaderIntake,
  NotFound,
  OneOffFormWrapper,
  RedeemTechDomain,
  StartPage,
  WorkshopWrapper,
} from './containers'

import './styles'

export default (store) => {
  return (
    <Route path="/" component={App}>
      <Route path="start" component={StartPage} />

      <Route path="workshops" component={WorkshopWrapper} />
      <Route path="workshops/*" component={WorkshopWrapper} />

      <Route component={OneOffFormWrapper}>
        <Route path="cloud9_setup" component={Cloud9Setup} />
        <Route path="hackbot/teams/new" component={HackbotNewTeam} />
        <Route path="intake" component={LeaderIntake} />
        <Route path="redeem_tech_domain" component={RedeemTechDomain} />
      </Route>

      <Route path="*" component={NotFound} status={404} />
    </Route>
  )
}
