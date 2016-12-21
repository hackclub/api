const info = {
  title: 'Hack Club',
  description: 'The worldwide movement of student-led coding clubs.'
}

export default {
  app: {
    title: info.title,
    description: info.description,
    head: {
      titleTemplate: '%s | Hack Club',
      defaultTitle: info.title,
      meta: [
        {name: 'description', content: info.description},
        {charset: 'utf-8'},
        {property: 'og:site_name', content: info.title},
        {property: 'og:locale', content: 'en_US'},
        {property: 'og:title', content: info.title},
        {property: 'og:description', content: info.description},
        {property: 'og:card', content: 'summary'}
      ]
    }
  },
  apiBaseUrl: process.env.REACT_APP_API_BASE_URL
}
