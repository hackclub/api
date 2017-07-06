import React, { Component } from 'react'
import Radium from 'radium'
import Helmet from 'react-helmet'
import Axios from 'axios'

import { NavBar, LoadingSpinner } from '../../components'
import { NotFound } from '../../containers'

import Workshop from './Workshop/Workshop'

const baseUrl = 'https://api.hackclub/v1/workshops/'

class WorkshopWrapper extends Component {
  constructor(props) {
    super(props)

    var rootUrl = baseUrl
    var extendedUrl = baseUrl + '/' + props.routeParams.splat
    var url = (props.routeParams.splat ? extendedUrl : rootUrl)

    this.requestWorkshop(url)
  }

  requestWorkshop(url) {
    Axios.get(url)
      .then(resp => this.placeWorkshop(resp.data))
      .catch(e => this.handleError(e, url))
  }

  placeWorkshop(data) {
    this.setState({
      notFound: false,
      markdown: data
    })
  }

  handleError(e, url) {
    var isNotFound = e.response.status === 404
    var isNotReadme = /README.md$/.exec(e.request.responseURL) === null
    if (isNotFound && isNotReadme) {
      this.requestWorkshop(url + '/README.md')
    } else {
      this.setState({
        notFound: true
      })
    }
  }

  getInitialState() {
    return {
      notFound: null
    }
  }

  content() {
    if (this.state.notFound === null) {
      return (<LoadingSpinner />)
    } else if(this.state.notFound === false) {
        return (<Workshop markdown={this.state.markdown}/>)
    } else {
      return (<NotFound />)
    }
  }

  render() {
    return(
      <div>
       <Helmet title={this.state.path || 'Workshops'} />
       <NavBar />
       {this.content()}
      </div>
    )
  }
}

export default Radium(WorkshopWrapper)
