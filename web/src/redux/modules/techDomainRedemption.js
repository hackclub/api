const SUBMIT = 'hackclub/techDomainRedemption/SUBMIT'
const SUBMIT_SUCCESS = 'hackclub/techDomainRedemption/SUBMIT_SUCCESS'
const SUBMIT_FAIL = 'hackclub/techDomainRedemption/SUBMIT_FAIL'

const initialState = {
  status: null
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case SUBMIT:
      return state
    case SUBMIT_SUCCESS:
      return {
        ...state,
        status: 'success'
      }
    case SUBMIT_FAIL:
      return {
        ...state,
        status: 'error'
      }
    default:
      return state
  }
}

export function submit(name, email, requestedDomain, secretCode) {
  return {
    types: [SUBMIT, SUBMIT_SUCCESS, SUBMIT_FAIL],
    promise: client =>
      client.post('/v1/tech_domain_redemptions', {
        data: {
          name,
          email,
          requested_domain: requestedDomain,
          secret_code: secretCode
        }
      })
  }
}
