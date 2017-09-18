const SUBMIT = 'hackclub/slackInvite/SUBMIT'
const SUBMIT_SUCCESS = 'hackclub/slackInvite/SUBMIT_SUCCESS'
const SUBMIT_FAIL = 'hackclub/slackInvite/SUBMIT_FAIL'

const initialState = {
  status: null
}

export default function reducer(state=initialState, action={}) {
  switch (action.type) {
  case SUBMIT:
    return state
  case SUBMIT_SUCCESS:
    return {
      ...state,
      status: "success"
    }
  case SUBMIT_FAIL:
    return {
      ...state,
      status: "error"
    }
  default:
    return state
  }
}

export function submit(email, username, full_name, password) {
  return {
    types: [SUBMIT, SUBMIT_SUCCESS, SUBMIT_FAIL],
    promise: client => client.post('/v1/slack_invitation/invite', {
      data: {
        email: email,
        username: username,
        full_name: full_name,
        password: password
      }
    })
  }
}
