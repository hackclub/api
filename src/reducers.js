import { combineReducers } from 'redux'
import { reducer as formReducer } from 'redux-form'
import {
  SUBMIT_LEADER, RECEIVE_LEADER
} from './actions'

function leader(state = {
  isSubmitting: false,
  createdLeader: null
}, action) {
  switch (action.type) {
  case SUBMIT_LEADER:
    return Object.assign({}, state, {
      isSubmitting: true
    })
  case RECEIVE_LEADER:
    return Object.assign({}, state, {
      isSubmitting: false,
      createdLeader: action.leader
    })
  default:
    return state
  }
}

const rootReducer = combineReducers({
  leader,
  form: formReducer
})

export default rootReducer
