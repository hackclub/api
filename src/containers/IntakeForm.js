import React, { Component, PropTypes } from 'react'
import Radium from 'radium'
import { Field, reduxForm } from 'redux-form'
import { ThreeBounce } from 'better-react-spinkit'

const styles = {
  base: {
    marginTop: '40px',
    marginBottom: '40px',

    marginLeft: 'auto',
    marginRight: 'auto',

    backgroundColor: '#ffffff',
    width: '350px',
    padding: '17.5px',
    paddingBottom: '5px',
    border: '1px solid #cccccc',
    boxShadow: '0px 1px 50px -15px #888888',
    borderRadius: '3px'
  },
  formGroup: {
    marginBottom: '15px'
  },
  label: {
    display: 'block',
    marginBottom: '5px',

    fontSize: '18px',
    fontWeight: '600'
  },
  field: {
    fontFamily: 'inherit',
    fontSize: '16px',
    color: '#575757',

    width: '100%',
    boxSizing: 'border-box',
    display: 'block',

    paddingTop: '7px',
    paddingLeft: '6px',
    paddingRight: '6px',
    paddingBottom: '6px',

    borderRadius: '3px',
    border: '1px solid #cccccc',

    ':placeholder': {
      fontStyle: 'italic',
      color: '#b3b3b3'
    }
  },
  select: {
    fontFamily: 'inherit',
    fontSize: '16px',
    color: '#575757',

    width: '100%',
    boxSizing: 'border-box',
    display: 'block',

    paddingTop: '7px',
    paddingLeft: '6px',
    paddingRight: '6px',
    paddingBottom: '6px',

    borderRadius: '3px',
    border: '1px solid #cccccc',

    background: 'none'
  },
  button: {
    fontFamily: 'inherit',
    fontSize: '16px',
    color: '#575757',

    width: '100%',
    boxSizing: 'border-box',
    display: 'block',

    paddingTop: '7px',
    paddingLeft: '6px',
    paddingRight: '6px',
    paddingBottom: '6px',

    borderRadius: '3px',
    border: '1px solid #cccccc',

    backgroundColor: '#e42d40',

    fontSize: '20px',
    fontWeight: 'bold',
    color: '#ffffff',

    border: 'none',
    height: '50px',
    cursor: 'pointer',

    ':disabled': {
      cursor: 'default'
    }
  },
  spinner: {
    backgroundColor: '#ffffff'
  }
}

class IntakeForm extends Component {
  render() {
    const { isSubmitting, submissionError, didSucceed, handleSubmit } = this.props

    let submitButtonContents = null

    if (isSubmitting) {
      submitButtonContents =
        <ThreeBounce color="white" size="15" />
    } else if (didSucceed) {
      submitButtonContents = <span>👍</span>
    } else if (submissionError) {
      submitButtonContents = <span>👎</span>
    } else {
      submitButtonContents = <span>Submit →</span>
    }

    return (
      <form style={styles.base} onSubmit={handleSubmit}>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="name">First and last name</label>
          <Field style={styles.field} name="name" component="input" type="text"
                 placeholder="Zaphod Beeblebrox" />
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="email">Preferred email</label>
          <Field style={styles.field} name="email" component="input" type="text"
                 placeholder="zaphod@beeblebrox.com" />
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="gender">Gender</label>
        <Field style={styles.select} name="gender" component="select">
            <option></option>
            <option value="Female">Female</option>
            <option value="Male">Male</option>
            <option value="Other">Other</option>
          </Field>
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="year">Year you'll graduate from high school</label>
          <Field style={styles.select} name="year" component="select">
            <option></option>
            <option value="2022">2022</option>
            <option value="2021">2021</option>
            <option value="2020">2020</option>
            <option value="2019">2019</option>
            <option value="2018">2018</option>
            <option value="2017">2017</option>
            <option value="2016">2016</option>
            <option value="Teacher">I'm a teacher</option>
          </Field>
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="phone_number">Phone number</label>
          <Field style={styles.field} name="phone_number" component="input" type="text"
                 placeholder="+1 (424) 424-4242" />
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="slack_username">Slack username</label>
          <Field style={styles.field} name="slack_username" component="input" type="text"
                 placeholder="zaphod"/>
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="github_username">GitHub username</label>
          <Field style={styles.field} name="github_username" component="input" type="text"
                 placeholder="zbeeblebrox" />
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="twitter_username">Twitter username (if you have one)</label>
          <Field style={styles.field} name="twitter_username" component="input" type="text"
                 placeholder="bigzaphod" />
        </div>
        <div style={styles.formGroup}>
          <label style={styles.label} htmlFor="address">Full address (include state and zip code)</label>
          <Field style={styles.field} name="address" component="textarea"
                 placeholder="4301 Beeblebrox Way, Galaxy City, CA 90210" />
        </div>
        <div style={styles.formGroup}>
          <button style={styles.button} type="submit" disabled={isSubmitting || didSucceed}>
            {submitButtonContents}
          </button>
        </div>
      </form>
    )
  }
}

IntakeForm.propTypes = {
  onSubmit: PropTypes.func.isRequired,
  isSubmitting: PropTypes.bool.isRequired,
  submissionError: PropTypes.string,
  didSucceed: PropTypes.bool
}

IntakeForm = reduxForm({
  form: 'intake'
})(IntakeForm)

export default Radium(IntakeForm)
