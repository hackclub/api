import { createValidator, required, email } from '../../utils/validation'

export default createValidator({
  name: [required],
  email: [required, email]
})
