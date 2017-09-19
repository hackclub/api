import { createValidator, required, email, slackPassword } from 'utils/validation'

export default createValidator({
  email: [required, email],
  username: [required],
  full_name: [required],
  password: [required, slackPassword]
})
