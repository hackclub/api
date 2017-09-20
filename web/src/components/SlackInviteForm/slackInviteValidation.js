import { createValidator, required, email/*, slackPassword*/ } from 'utils/validation'

export const validate = createValidator({
  email: [required, email],
  username: [required],
  full_name: [required],
  password: [required]
})

export function asyncValidate(data) {
  const value = data.password
  if (!value) {
    return Promise.resolve({})
  }

  return fetch(`https://slack.com/api/signup.checkPasswordComplexity?password=${value}`)
    .then(response => {
      return response.json()
    })
    .then(json => {
      if (json.ok) {
        Promise.resolve()
      } else {
        const descriptions = {
          repeated: "Password can't just be a repeated character",
          common: "Password can't be a common word",
          too_short: 'Password must be at least 6 characters',
        }
        return {password: descriptions[json.error] || json.error}
      }
    })
    .catch(e => {
      console.log(`Password couldn't be validated: ${e}`)
    })
  return new Promise(resolve => {setTimeout(resolve, 1000)}).then(() => {
    if(value === 'password') {
      throw {password: 'that password sucks'}
    }
  })
}
