import { createValidator, required, email } from '../../utils/validation'

export default createValidator({
  first_name: [required],
  last_name: [required],
  email: [required, email],
  year: [required],
  interesting_project: [required],
  systems_hacked: [required],
  first_steps: [required],
  referer: [required]
})
