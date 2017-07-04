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
    Axios.get(baseUrl + (props.routeParams.splat || ''))
         .then(resp => {
           this.setState({
             notFound: false,
             markdown: resp.data
           })
         })
         .catch(e => {
           console.log(e)
           this.setState({
             notFound: true
           })
         })
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
