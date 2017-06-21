import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import application from './application'
import cloud9Setup from './cloud9Setup'
import clubs from './clubs'
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
  form
})
