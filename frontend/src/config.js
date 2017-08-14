export default {
  head: {
    titleTemplate: '%s | Hack Club',
    defaultTitle: 'Hack Club'
  },
  apiBaseUrl: process.env.REACT_APP_API_BASE_URL,
  slackClientId: process.env.REACT_APP_SLACK_CLIENT_ID,
  stripePublishableKey: process.env.REACT_APP_STRIPE_PUBLISHABLE_KEY,
  googleAnalyticsId: process.env.REACT_APP_GOOGLE_ANALYTICS_ID
}
