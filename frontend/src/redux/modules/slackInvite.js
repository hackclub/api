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

export function submit(email) {
  return {
    types: [SUBMIT, SUBMIT_SUCCESS, SUBMIT_FAIL],
    promise: client => client.post('/v1/slack/send_invite', {
      data: {
        email: email
      }
    })
  }
}
