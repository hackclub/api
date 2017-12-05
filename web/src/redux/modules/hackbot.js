const AUTH = 'hackclub/hackbot/AUTH'
const AUTH_SUCCESS = 'hackclub/hackbot/AUTH_SUCCESS'
const AUTH_FAIL = 'hackclub/hackbot/AUTH_FAIL'

export const STATUS_SUCCESS = 'success'
export const STATUS_ERROR = 'error'

const initialState = {
  auth: {
    status: null
  }
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case AUTH:
      return state
    case AUTH_SUCCESS:
      return {
        ...state,
        auth: {
          ...state.auth,
          status: STATUS_SUCCESS
        }
      }
    case AUTH_FAIL:
      return {
        ...state,
        auth: {
          ...state.auth,
          status: STATUS_ERROR
        }
      }
    default:
      return state
  }
}

export function auth(oauthCode) {
  return {
    types: [AUTH, AUTH_SUCCESS, AUTH_FAIL],
    promise: client =>
      client.post('/v1/hackbot/auth', {
        data: {
          code: oauthCode
        }
      })
  }
}
