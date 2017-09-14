import React, { Component } from 'react'
import Radium, { Style } from 'radium'
import Marked from 'marked'
import Hljs from 'highlight.js'

import colors from 'styles/colors'
import './githubMarkdown.css'
import './highlightjs.css'

const styles = {
  '.markdown-body': {
    fontFamily: 'inherit',
    fontWeight: 'inherit',
  },
  '.markdown-body a': {
    color: colors.primary,
  },
  '.markdown-body a:hover': {
    color: colors.fadedPrimary,
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
    const { imagesUrl, location, markdown } = this.props

    renderer.link = (href, title, text) => {
      const pathname = location.pathname

      /* Links in the root /workshops directory need a trailing slash to generate
       * correctly */
      const safePathname = (pathname === '/workshops' ? '/workshops/' : pathname)

      const isRelativeLink = !/^(http|https):\/\//.test(href)
      const isHashLink = /^#/.test(href)

      if (isHashLink) {
        href = safePathname + href
      } else if (isRelativeLink) {
        const folderName = /.*\//.exec(safePathname)[0]
        href = folderName + href
      }

      const titleAttr = (title ? `title="${title}"` : '')

      return `<a href="${href}"${titleAttr}>${text}</a>`
    }

    renderer.image = (href, title, text) => {
      const isRelativeLink = !/^(http|https):\/\//.test(href)
      if (isRelativeLink) {
        href = imagesUrl.replace(/([^/]*)$/, href)
      }
      const titleAttr =  title ? `title="${title}"` : ''
      const altAttr = text ? ` alt="${text}"` : ''
      return `<img src="${href}"${titleAttr}${altAttr} />`
    }

    const html = Marked(markdown, { renderer: renderer })

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
