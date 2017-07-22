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

const renderer = new Marked.Renderer();

Marked.setOptions({
  highlight: (code) => {
    return Hljs.highlightAuto(code).value
  }
})

class Workshop extends Component {
  createWorkshop() {
    var { imagesUrl, location, markdown } = this.props
      var pathname = location.pathname

      renderer.link = (href, title, text) => {
          var isRelativeLink = !/^(http|https):\/\//.test(href)
          var isHashLink = /^#/.test(href)

          if (isHashLink) {
              href = pathname + href
          } else if (isRelativeLink) {
              var folderName = /.*\//.exec(pathname)[0]
              href = folderName + href
          }

          var titleAttr = (title ? `title="${title}"` : '')

          return `<a href="${href}"${titleAttr}>${text}</a>`
      }

    renderer.image = (href, title, text) => {
      var isRelativeLink = !/^(http|https):\/\//.test(href)
      if (isRelativeLink) {
        href = imagesUrl.replace(/([^/]*)$/, href)
      }
      var titleAttr =  title ? `title="${title}"` : ''
      var altAttr = text ? ` alt="${text}"` : ''
      return `<img src="${href}"${titleAttr}${altAttr} />`
    }

    var html = Marked(markdown, { renderer: renderer })

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
