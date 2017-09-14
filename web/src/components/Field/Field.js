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
  tooltip: {
    fontSize: '14px',
    fontWeight: '300',
    marginBottom: '5px'
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

  tooltip() {
    const { tooltip } = this.props

    if (tooltip) {
      return (<p style={styles.tooltip}>{tooltip}</p>)
    }
  }

  render() {
    const { label, meta={} } = this.props
    const { touched, error } = meta

    return (
      <div style={styles.formGroup}>
        <label style={styles.label}>{label}</label>
        {this.tooltip()}
        <div>
          { this.renderInput() }
          { touched && error && <div style={styles.error}>{error}</div> }
        </div>
      </div>
    )
  }
}

export default Field
