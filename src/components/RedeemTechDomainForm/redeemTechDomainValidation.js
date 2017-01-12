import { createValidator, required, email, techDomain } from '../../utils/validation'

export default createValidator({
  name: [required],
  email: [required, email],
  requested_domain: [required, techDomain],
  secret_code: [required]
})
