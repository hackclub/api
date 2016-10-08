import { combineReducers } from 'redux'
import { reducer as formReducer } from 'redux-form'
import {
  RECEIVE_LEADER
} from './actions'

function leader(state={createdLeader: null}, action) {
  switch (action.type) {
  case RECEIVE_LEADER:
    return Object.assign({}, state, {
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
