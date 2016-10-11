import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'

import leaderIntake from './leaderIntake'
import { reducer as form } from 'redux-form'

export default combineReducers({
  routing: routerReducer,
  leaderIntake,
  form
})
