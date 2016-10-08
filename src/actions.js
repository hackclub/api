import 'isomorphic-fetch'

export const RECEIVE_LEADER = 'RECEIVE_LEADER'

function receiveLeader(json) {
  return {
    type: RECEIVE_LEADER,
    leader: json
  }
}

export function createLeader(leader) {
  return dispatch => {
    return fetch('https://api.hackclub.com/v1/leaders/intake', {
      method: 'POST',
      headers: new Headers({
        'Content-Type': 'application/json'
      }),
      body: JSON.stringify(leader)
    })
      .then(resp => resp.json())
      .then(json => dispatch(receiveLeader(json)))
  }
}
