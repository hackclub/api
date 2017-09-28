export default {
  head: {
    titleTemplate: '%s | Hack Club',
    defaultTitle: 'Hack Club'
  },
  apiBaseUrl: process.env.REACT_APP_API_BASE_URL,
  segmentKey: process.env.REACT_APP_SEGMENT_KEY,
  slackClientId: process.env.REACT_APP_SLACK_CLIENT_ID,
  stripePublishableKey: process.env.REACT_APP_STRIPE_PUBLISHABLE_KEY
}
