const AUTH = 'hackclub/slack_auth/AUTH'
const AUTH_SUCCESS = 'hackclub/leader_intake/AUTH_SUCCESS'
const AUTH_FAIL = 'hackclub/leader_intake/AUTH_FAIL'

export const STATUS_SUCCESS = 'success'
export const STATUS_ERROR = 'error'

const initialState = {
  status: null
}

export default function reducer(state=initialState, action={}) {
  switch (action.type) {
  case AUTH:
    return state
  case AUTH_SUCCESS:
    return {
      ...state,
      status: STATUS_SUCCESS
    }
  case AUTH_FAIL:
    return {
      ...state,
      status: STATUS_ERROR
    }
  default:
    return state
  }
}

export function auth(oauthCode) {
  return {
    types: [AUTH, AUTH_SUCCESS, AUTH_FAIL],
    promise: client => client.post('/v1/hackbot/auth', {
      data: {
        code: oauthCode
      }
    })
  }
}
