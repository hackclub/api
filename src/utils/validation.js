const isEmpty = value =>
        value === undefined ||
        value === null ||
        value === ''

const join = (rules) => (value, data) => rules.map(rule => rule(value, data)).filter(error => !!error)[0 /* first error */ ];

export function required(value) {
  if (isEmpty(value)) {
    return 'Required'
  }
}

const emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
export function email(value) {
  if (!isEmpty(value) && !emailRegex.test(value)) {
    return 'Invalid email address'
  }
}

const techDomainRegex = /^[A-Z0-9.-]+\.tech$/i
export function techDomain(value) {
  if (!isEmpty(value) && !techDomainRegex.test(value)) {
    return 'Invalid domain'
  }
}

// Here be dragons.
//
// Taken from https://github.com/erikras/react-redux-universal-hot-example/blob/37202692fd2e8ba99bc1ad2f38378bebf361862c/src/utils/validation.js#L57-L69
export function createValidator(rules) {
  return (data = {}) => {
    const errors = {}
    Object.keys(rules).forEach(key => {
      const rule = join([].concat(rules[key]))
      const error = rule(data[key], data)
      if (error) {
        errors[key] = error
      }
    })
    return errors
  }
}
