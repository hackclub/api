import { createValidator, required, email, techDomain } from '../../utils/validation'

export default createValidator({
  name: [required],
  email: [required, email],
  domain: [required, techDomain]
})
