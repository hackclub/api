import React, { Component } from 'react'
import Radium from 'radium'
import { ThreeBounce } from 'better-react-spinkit'
import Helmet from 'react-helmet'
import { NavBar, Header, Heading, Button, Card, HorizontalRule, Emoji } from '../../components'

import { mediaQueries } from '../../styles/common'
import colors from '../../styles/colors'
import config from '../../config'

const styles = {
  card: {
    marginTop: '80px',
    marginLeft: 'auto',
    marginRight: 'auto',

    maxWidth: '1000px'
  },
  heading: {
    fontSize: '2rem'
  },
  subheading: {
    fontSize: '1.5rem'
  },
  info: {
    marginBottom: '30px'
  },
  input: {
    fontFamily: 'inherit',
    fontSize: '16px',
    color: colors.userInput,
    width: '100%',
    boxSizing: 'border-box',
    display: 'block',
    paddingTop: '7px',
    paddingLeft: '6px',
    paddingRight: '6px',
    paddingBottom: '6px',
    borderRadius: '3px',
    border: `1px solid ${colors.outline}`
  },
  label: {
    display: 'block',
    marginBottom: '5px',
    fontSize: '18px',
    fontWeight: '600'
  },
  inlineLabel: {
    display: 'inline'
  },
  donateTier: {
    transition: 'all .25s',

    backgroundColor: 'rgb(225, 225, 225)', // colors.lightGray,

    padding: '15px',
    marginRight: '15px',

    fontFamily: 'inherit',
    fontSize: '20px',
    fontWeight: '400',
    color: colors.darkGray,

    border: 'none',

    cursor: 'pointer',
  },
  donateTierActive: {
    color: colors.bg,
    backgroundColor: colors.primary,
  },
  donateAmountOptions: {
    paddingBottom: '10px'
  },
  donateButton: {
    marginTop: '30px'
  },
  rule: {
    marginBottom: '20px',
    marginTop: '10px'
  }
}

class Cards extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      stripeLoading: true,
      amount: 50,
      recurring: true,
      custom: false
    };

    // onStripeUpdate must be bound or else clicking on button will produce error.
    this.onStripeUpdate = this.onStripeUpdate.bind(this);
    // binding loadStripe as a best practice, not doing so does not seem to cause error.
    this.loadStripe = this.loadStripe.bind(this);
    this.handleAmountChange = this.handleAmountChange.bind(this);
    this.handleRecurringChange = this.handleRecurringChange.bind(this)
    this.setCustom = this.setCustom.bind(this)
    this.pay = this.pay.bind(this);
  }

  loadStripe(onload) {
    if(! window.StripeCheckout) {
      const script = document.createElement('script');
      script.onload = function () {
        console.info("Stripe script loaded");
        onload();
      };

      script.src = 'https://checkout.stripe.com/checkout.js';
      document.head.appendChild(script);
    } else {
      onload();
    }
  }

  startStripe(e) {
    this.loadStripe(() => {
      this.stripeHandler = window.StripeCheckout.configure({
        key: config.stripePublishableKey,
        image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
        locale: 'auto',
        amount: this.amountInCents(),
        token: (token) => {
          this.setState({ loading: true })

          var data = new FormData()

          data.append("stripe_email", token.email)
          data.append("stripe_token", token.id)
          data.append("recurring", this.state.recurring)
          data.append('amount', this.amountInCents())

          this.setState({status: 'loading'})

          fetch(config.apiBaseUrl + '/v1/donations', {method: 'post', body: data })
            .then(resp => {
              return resp.json()
            }).then(data => {
              if (data.donation_successful) {
                this.setState({status: 'done'})
              } else {
                this.setState({status: 'error'})
              }
            }).catch( () => {
                this.setState({status: 'error'})
            })
        }
      });

      this.setState({
        stripeLoading: false,
        // loading needs to be explicitly set false so component will render in 'loaded' state.
        loading: false,
      });

      this.onStripeUpdate(e)
    });
  }

  componentWillUnmount() {
    if(this.stripeHandler) {
      this.stripeHandler.close();
    }
  }

  onStripeUpdate(e) {
    this.stripeHandler.open({
      name: 'Hack Club',
      description: 'Hack Club contribution.',
      panelLabel: 'Donate',
      allowRememberMe: false,
    });

    e.preventDefault();
  }

  amountInCents() {
    return this.state.amount * 100;
  }

  handleAmountChange(v) {
    var num = v.target.value.replace( /^\D+.\D*/g, '') || "1";

    this.setState({ amount: parseFloat(num)})
  }

  handleRecurringChange(v) {
    this.setState({ recurring: v.target.checked })
  }

  pay(e) {
    this.startStripe(e)
  }

  buttonText() {
    if (this.state.status == "done") {
      return <span><Emoji type="grinning_face"/>Done! Thanks for your donation</span>
    } else if (this.state.status == "loading") {
      return <ThreeBounce size={15} color={colors.bg} />
    } else if (this.state.status == "error") {
      return 'Something went wrong! Try again soon.'
    } else {
      let msg = `Donate $${this.state.amount}`

      if (this.state.recurring) {
        msg = `${msg} a month`
      }

      return msg + '!'
    }
  }

  setAmount(amount) {
    return (v) => {
      this.setState({ amount, custom: false })
    }
  }

  setCustom() {
    this.setState({ custom: true })
  }

  renderCustomAmount() {
    if (this.state.custom) {
      return <input
        name="amount"
        type="number"
        value={this.state.amount}
        onChange={this.handleAmountChange}
        style={styles.input}
        min="1"
        step="1" />
    }
  }

  renderDonationTier(amount) {
    const active = this.state.amount == amount && !this.state.custom

    return <button
              style={[styles.donateTier, active ? styles.donateTierActive : {}]}
              onClick={this.setAmount(amount)}>

           ${amount}

           </button>
  }

  render() {
    const { stripeLoading, loading } = this.state;

    return (
      <div>
        <div style={styles.donateAmountOptions}>
        { this.renderDonationTier(15) }
        { this.renderDonationTier(50) }
        { this.renderDonationTier(150) }
        { this.renderDonationTier(300) }

        <button
          style={[styles.donateTier, this.state.custom ? styles.donateTierActive : {}]}
          onClick={this.setCustom}>
          Custom
        </button>
        </div>

        { this.renderCustomAmount() }


        <br />

        <label style={[styles.label, styles.inlineLabel]} htmlFor="recurring">Monthly payment?</label>
        <input name="recurring" type="checkbox" value={this.state.recurring} onChange={this.handleRecurringChange} />
        <br />
        <br />

        <p style={styles.taxDeductible}>Your contribution is tax deductible!</p>

        <Button style={styles.donateButton} onClick={this.pay} type='link'>{this.buttonText()}</Button>
      </div>
    );
  }
}

const PayWithStripe = Radium(Cards)

class Donations extends Component {
  render() {
    return (
      <div>
        <Helmet title="Donations" />

        <NavBar />

        <Card style={styles.card}>
          <div style={styles.info}>
            <Heading style={styles.heading}>Hack Club brings free coding clubs to high schools worldwide</Heading>

            <p style={styles.subheading}>It costs us just $3 each month to support a student in Hack Club.</p>
          </div>

          <HorizontalRule style={styles.rule} />

          <PayWithStripe />
        </Card>
      </div>
    )
  }
}

export default Radium(Donations)
