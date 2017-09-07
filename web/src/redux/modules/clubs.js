const LOAD = 'hackclub/clubs/LOAD'
const LOAD_SUCCESS = 'hackclub/clubs/LOAD_SUCCESS'
const LOAD_FAIL = 'hackclub/clubs/LOAD_FAIL'

const initialState = {
  loaded: false
}

export default function reducer(state=initialState, action={}) {
  switch (action.type) {
  case LOAD:
    return {
      ...state,
      loading: true
    }
  case LOAD_SUCCESS:
    return {
      ...state,
      loading: false,
      loaded: true,
      data: action.result,
      error: null
    }
  case LOAD_FAIL:
    return {
      ...state,
      loading: false,
      loaded: false,
      data: null,
      error: action.error
    }
  default:
    return state
  }
}

export function isLoaded(globalState) {
  return globalState.clubs && globalState.clubs.loaded
}

export function load() {
  return {
    types: [LOAD, LOAD_SUCCESS, LOAD_FAIL],
    promise: client => client.get('/v1/clubs/to_be_onboarded')
  }
}
