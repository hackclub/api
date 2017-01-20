const PREAPP_SUBMIT_PERSON_TYPE = 'hackclub/application/PREAPP_SUBMIT_PERSON_TYPE'
const PREAPP_RESET = 'hackclub/application/PREAPP_RESET'

const initialState = {
  preApplication: {
    personType: null
  }
}

export default function reducer(state=initialState, action={}) {
  switch(action.type) {
  case PREAPP_SUBMIT_PERSON_TYPE:
    return {
      ...state,
      preApplication: {
        ...state.preApplication,
        personType: action.personType
      }
    }
  case PREAPP_RESET:
    return {
      ...state,
      preApplication: initialState.preApplication
    }
  default:
    return state
  }
}

export const personTypes = {
  student: 'STUDENT',
  teacher: 'TEACHER',
  parent: 'PARENT',
  other: 'OTHER'
}

export function preAppSubmitPersonType(personType) {
  return {
    type: PREAPP_SUBMIT_PERSON_TYPE,
    personType
  }
}

export function preAppReset() {
  return {
    type: PREAPP_RESET
  }
}
