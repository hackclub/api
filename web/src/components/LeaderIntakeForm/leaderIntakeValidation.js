import { createValidator, required, email } from 'utils/validation'

export default createValidator({
  name: [required],
  email: [required, email],
  club_id: [required],
  gender: [required],
  year: [required],
  phone_number: [required],
  github_username: [required],
  address: [required]
})
