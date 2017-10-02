import {
  createValidator,
  required,
  email,
  slackUsername
} from 'utils/validation'

export const validate = createValidator({
  email: [required, email],
  username: [required, slackUsername],
  full_name: [required],
  password: [required]
})

function createSlackValidator(
  value,
  endpoint,
  param,
  errorDescriptions = {},
  field
) {
  if (!value) {
    return
  }
  return fetch(
    `https://slack.com/api/signup.${endpoint}?${param}=${encodeURIComponent(
      value
    )}`
  )
    .then(response => {
      return response.json()
    })
    .then(json => {
      if (json.ok) {
        Promise.resolve()
      } else {
        return { [field || param]: errorDescriptions[json.error] || json.error }
      }
    })
    .catch(e => {
      console.log(`${field} couldn't be validated: ${e}`)
    })
}

export function asyncValidate(data) {
  return Promise.all([
    createSlackValidator(data.email, 'checkEmail', 'email', {
      invalid_email: 'Invalid email'
    }),
    createSlackValidator(data.username, 'checkUsername', 'username', {
      long_username: 'Username is too long',
      bad_username:
        'Username can only contain lowercase letters, numbers, and underscores'
    }),
    createSlackValidator(data.password, 'checkPasswordComplexity', 'password', {
      repeated: "Password can't just be a repeated character",
      common: "Password can't be a common word",
      too_short: 'Password must be at least 6 characters'
    })
  ]).then(arr => {
    var results = {}
    arr.forEach(result => {
      results = { ...results, ...result }
    })
    if (results === {}) {
      Promise.resolve()
    } else {
      return results
    }
  })
}
