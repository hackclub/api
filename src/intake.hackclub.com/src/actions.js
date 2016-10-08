import 'isomorphic-fetch'

export const CREATE_LEADER_REQUEST_BEGIN = 'CREATE_LEADER_REQUEST_BEGIN'
export const CREATE_LEADER_REQUEST_SUCCEED = 'CREATE_LEADER_REQUEST_SUCCEED'
export const CREATE_LEADER_REQUEST_FAIL = 'CREATE_LEADER_REQUEST_FAIL'

function createLeaderRequestBegin(leader) {
  return {
    type: CREATE_LEADER_REQUEST_BEGIN,
    leader
  }
}

function createLeaderRequestSucceed(json) {
  return {
    type: CREATE_LEADER_REQUEST_SUCCEED,
    leader: json
  }
}

function createLeaderRequestFail(err) {
  return {
    type: CREATE_LEADER_REQUEST_FAIL,
    error: err
  }
}

export function createLeader(leader) {
  return dispatch => {
    dispatch(createLeaderRequestBegin(leader))
    return fetch('https://api.hackclub.com/v1/leaders/intake', {
      method: 'POST',
      headers: new Headers({
        'Content-Type': 'application/json'
      }),
      body: JSON.stringify(leader)
    })
      .then(resp => {
        if (!resp.ok) {
          throw Error(resp.statusText)
        }

        return resp.json()
      })
      .then(json => dispatch(createLeaderRequestSucceed(json)))
      .catch(err => dispatch(createLeaderRequestFail(err)))
  }
}
