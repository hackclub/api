import { createValidator, required, email } from '../../utils/validation'

export default createValidator({
  firstName: [required],
  lastName: [required],
  email: [required, email],
  year: [required],
  interestingProject: [required],
  hack: [required],
  firstSteps: [required],
  referral: [required]
})
