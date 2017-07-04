import React, { Component } from 'react'
import Radium, { Style } from 'radium'
import Marked from 'marked'
import Hljs from 'highlight.js'

import brandPreferences from '../../../styles/colors'
import './githubMarkdown.css'

const styles = {
  '.markdown-body': {
    fontFamily: 'inherit',
    fontWeight: 'inherit',
  },
  '.markdown-body a': {
    color: brandPreferences.primary,
  },
  '.markdown-body a:hover': {
    color: brandPreferences.fadedPrimary,
    textDecoration: 'line',
  },
  '.markdown-body ul': {
    listStyleType: 'disc',
  },
  '.markdown-body ol': {
    listStyleType: 'decimal',
  },
  '.markdown-body em': {
    fontStyle: 'italic',
  }
}

Marked.setOptions({
  highlight: (code, lang, callback) => {
    return Hljs.highlightAuto(code).value
  }
})

class Workshop extends Component {
  createWorkshop() {
    return {__html: Marked(this.props.markdown)}
  }

  render() {
    return(
      <div>
        <Style rules={styles} />
        <div className='markdown-body' dangerouslySetInnerHTML={this.createWorkshop()} />
      </div>
    )
  }
}

export default Radium(Workshop)
