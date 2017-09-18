import { createValidator, required, email } from 'utils/validation'

export default createValidator({
  email: [required, email],
  username: [required],
  full_name: [required],
  password: [required]
})
