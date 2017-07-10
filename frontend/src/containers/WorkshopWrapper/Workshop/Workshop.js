import React, { Component } from 'react'
import Radium, { Style } from 'radium'
import Marked from 'marked'
import Hljs from 'highlight.js'

import brandPreferences from '../../../styles/colors'
import './githubMarkdown.css'
import './highlightjs.css'

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

const renderer = new Marked.Renderer();

class Workshop extends Component {
  createWorkshop() {
    renderer.link = (href, title, text) => {
        var isRelativeLink = !/^(http|https):\/\//.test(href)
        if (isRelativeLink) {
            href = 'https://hackclub-dev.ngrok.io/workshops/' + href
        }
        return `<a href="${href}" title="${title}">${text}</a>`
    }

    renderer.image = (href, title, text) => {
      var isRelativeLink = !/^(http|https):\/\//.test(href)
      if (isRelativeLink) {
        href = this.props.workshopUrl.replace(/([^/]*)$/, href)
      }
      return `<img src="${href}" title="${title}" alt="${text}" />`
    }

    var html = Marked(this.props.markdown, { renderer: renderer })

    return {__html: html}
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
