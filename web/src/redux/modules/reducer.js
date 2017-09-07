import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import application from './application'
import cloud9Setup from './cloud9Setup'
import slackInvite from './slackInvite'
import clubs from './clubs'
import apply from './apply'
import hackbot from './hackbot'
import leaderIntake from './leaderIntake'
import techDomainRedemption from './techDomainRedemption'
import { reducer as form } from 'redux-form'

export default combineReducers({
  routing: routerReducer,
  application,
  cloud9Setup,
  clubs,
  hackbot,
  leaderIntake,
  techDomainRedemption,
  apply,
  slackInvite,
  form,
})
