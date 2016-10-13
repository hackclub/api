const SUBMIT = 'hackclub/leader_intake/SUBMIT'
const SUBMIT_SUCCESS = 'hackclub/leader_intake/SUBMIT_SUCCESS'
const SUBMIT_FAIL = 'hackclub/leader_intake/SUBMIT_FAIL'

const initialState = {
  errors: {},
  status: null
}

export default function reducer(state=initialState, action={}) {
  switch (action.type) {
  case SUBMIT:
    return state // 'saving' flag handled by redux-form
  case SUBMIT_SUCCESS:
    return {
      ...state,
      errors: {},
      status: "success"
    }
  case SUBMIT_FAIL:
    return {
      ...state,
      errors: action.errors,
      status: "error"
    }
  default:
    return state
  }
}

export function submit(leader) {
  return {
    types: [SUBMIT, SUBMIT_SUCCESS, SUBMIT_FAIL],
    promise: client => client.post('/v1/leaders/intake', {
      data: leader
    })
  }
}
