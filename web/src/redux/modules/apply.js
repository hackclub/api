const SUBMIT = 'hackclub/apply/SUBMIT'
const SUBMIT_SUCCESS = 'hackclub/apply/SUBMIT_SUCCESS'
const SUBMIT_FAIL = 'hackclub/apply/SUBMIT_FAIL'
const FORM_CHANGE = '@@redux-form/CHANGE'

const initialState = {
  status: null
}

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case SUBMIT:
      return state // 'saving' flag handled by redux-form
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
    case FORM_CHANGE:
      return {
        ...state,
        status: null
      }
    default:
      return state
  }
}

export function submit(application) {
  return {
    types: [SUBMIT, SUBMIT_SUCCESS, SUBMIT_FAIL],
    promise: client =>
      client.post('/v1/club_applications', {
        data: application
      })
  }
}
