import { combineReducers } from 'redux'
import { reducer as formReducer } from 'redux-form'
import {
  CREATE_LEADER_REQUEST_BEGIN, CREATE_LEADER_REQUEST_SUCCEED,
  CREATE_LEADER_REQUEST_FAIL
} from './actions'

function leader(state = {
  isSubmitting: false,
  submissionError: null,
  didSucceed: null
}, action) {
  switch (action.type) {
  case CREATE_LEADER_REQUEST_BEGIN:
    return Object.assign({}, state, {
      isSubmitting: true
    })
  case CREATE_LEADER_REQUEST_SUCCEED:
    return Object.assign({}, state, {
      isSubmitting: false,
      didSucceed: true
    })
  case CREATE_LEADER_REQUEST_FAIL:
    return Object.assign({}, state, {
      isSubmitting: false,
      didSucceed: false,
      submissionError: action.error.message
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
