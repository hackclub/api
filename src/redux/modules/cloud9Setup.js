const SUBMIT = 'hackclub/cloud9Setup/SUBMIT'
const SUBMIT_SUCCESS = 'hackclub/cloud9Setup/SUBMIT_SUCCESS'
const SUBMIT_FAIL = 'hackclub/cloud9Setup/SUBMIT_FAIL'

const initialState = {
  errors: {},
  status: null
}

export default function reducer(state=initialState, action={}) {
  switch (action.type) {
  case SUBMIT:
    return state
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

export function submit(email) {
  return {
    types: [SUBMIT, SUBMIT_SUCCESS, SUBMIT_FAIL],
    promise: client => client.post('/v1/cloud9/send_invite', {
      data: {
        email: email
      }
    })
  }
}
