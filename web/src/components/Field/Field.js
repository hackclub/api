import React, { Component } from 'react'

const styles = {
  formGroup: {
    marginBottom: '15px'
  },
  label: {
    display: 'block',
    lineHeight: '140%',
    marginBottom: '5px',
    fontSize: '18px',
    fontWeight: '600'
  },
  description: {
    fontSize: '16px',
    lineHeight: '140%',
    fontWeight: '300',
    marginBottom: '7px'
  },
  error: {
    fontSize: '14px',
    marginTop: '5px',
    fontStyle: 'italic'
  }
}

class Field extends Component {
  renderInput() {
    throw new TypeError("Cannot construct Field instances directly")
  }

  description() {
    const { description } = this.props

    if (description) {
      return (<p style={styles.description}>{description}</p>)
    }
  }

  render() {
    const { label, meta={} } = this.props
    const { touched, error } = meta

    return (
      <div style={styles.formGroup}>
        <label style={styles.label}>{label}</label>
        {this.description()}
        <div>
          { this.renderInput() }
          { touched && error && <div style={styles.error}>{error}</div> }
        </div>
      </div>
    )
  }
}

export default Field
