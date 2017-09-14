import { createValidator, required, email } from 'utils/validation'

export default createValidator({
  email: [required, email]
})
