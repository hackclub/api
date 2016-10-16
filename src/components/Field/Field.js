import React, { Component } from 'react'

const styles = {
  formGroup: {
    marginBottom: '15px'
  },
  label: {
    display: 'block',
    marginBottom: '5px',
    fontSize: '18px',
    fontWeight: 'bold'
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

  render() {
    const { label, meta: { touched, error } } = this.props

    return (
      <div style={styles.formGroup}>
        <label style={styles.label}>{label}</label>
        <div>
          { this.renderInput() }
          { touched && error && <div style={styles.error}>{error}</div>}
        </div>
      </div>
    )
  }
}

export default Field
