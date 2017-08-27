import React, { Component } from 'react'
import Radium from 'radium'
import { Button, Emoji, Subtitle } from '../../components'
import { ThreeBounce } from 'better-react-spinkit'

import colors from '../../styles/colors'
import config from '../../config'

import logo from './logo.png'

const styles = {
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
  customTier: {
    marginBottom: '5px'
  },
  donateAmountOptions: {
    paddingBottom: '10px'
  },
  donateButton: {
    marginBottom: '30px',
    marginTop: '30px'
  },
  isMonthly: {
    marginBottom: '10px'
  },
}

class DonationForm extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      stripeLoading: true,
      amount: 50,
      recurring: true,
      custom: false
    };

    // Have to bind our handlers to this because of how JavaScript's scope works.
    this.onStripeUpdate = this.onStripeUpdate.bind(this);
    this.startStripe = this.startStripe.bind(this);
    this.loadStripe = this.loadStripe.bind(this);
    this.handleToken = this.handleToken.bind(this);
    this.handleAmountChange = this.handleAmountChange.bind(this);
    this.handleRecurringChange = this.handleRecurringChange.bind(this)
    this.enableCustom = this.enableCustom.bind(this)
  }

  componentWillUnmount() {
    if(this.stripeHandler) {
      this.stripeHandler.close();
    }
  }

  render() {
    const { custom, recurring } = this.state
    return (
      <div>
        <div style={styles.donateAmountOptions}>
          { this.renderDonationTier(15) }
          { this.renderDonationTier(50) }
          { this.renderDonationTier(150) }
          { this.renderDonationTier(300) }

          <button
            style={[styles.donateTier, custom ? styles.donateTierActive : {}]}
            onClick={this.enableCustom}>
            Custom
          </button>
        </div>

        { this.renderCustomAmount() }

        <div style={styles.isMonthly}>
          <label style={[styles.label, styles.inlineLabel]} htmlFor="recurring">Monthly payment?</label>
          <input name="recurring" type="checkbox" checked={recurring}
                 onChange={this.handleRecurringChange}
          />
        </div>

        <p>Your contribution is tax deductible!</p>

        <Button style={styles.donateButton} onClick={this.startStripe} type='link'>{this.buttonText()}</Button>

        <Subtitle>Hack Club's nonprofit EIN is 81-290849.</Subtitle>
      </div>
    );
  }

  renderCustomAmount() {
    if (this.state.custom) {
      return <input
        name="amount"
        type="number"
        value={this.state.amount}
        onChange={this.handleAmountChange}
        style={[styles.input, styles.customTier]}
        min="1" />
    }
  }

  renderDonationTier(amount) {
    const active = this.state.amount === amount && !this.state.custom

    return <button
              style={[styles.donateTier, active ? styles.donateTierActive : {}]}
              onClick={this.setAmount(amount)}>

           ${amount}

           </button>
  }

  loadStripe(onload) {
    if(!window.StripeCheckout) {
      const script = document.createElement('script');
      script.onload = function () {
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
        image: logo,
        locale: 'auto',
        amount: this.amountInCents(),
        token: this.handleToken
      });

      this.setState({
        stripeLoading: false,
        // loading needs to be explicitly set false so component will render in 'loaded' state.
        loading: false,
      });

      this.onStripeUpdate(e)
    });
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

  handleToken(token) {
    this.setState({ loading: true })

    var data = new FormData()

    data.append("stripe_email", token.email)
    data.append("stripe_token", token.id)
    data.append("recurring", this.state.recurring)
    data.append('amount', this.amountInCents())

    this.setState({status: 'loading'})

    fetch(config.apiBaseUrl + '/v1/donations', { method: 'post', body: data })
      .then(resp => {
        return resp.json()
      }).then(data => {
        if (data.donation_successful) {
          this.setState({status: 'done'})
        } else {
          this.setState({status: 'error'})
        }
      }).catch(() => {
        this.setState({status: 'error'})
      })
  }

  handleAmountChange(v) {
    // This regex looks for any string which does not match out definition of a
    // number (1, 1.0, 1.66, etc.) and removes it. If the value is non-existant
    // then it gets set to 1.
    var num = v.target.value.replace( /^\D+.\D*/g, '') || "1";

    this.setState({ amount: parseFloat(num)})
  }

  handleRecurringChange(v) {
    this.setState({ recurring: v.target.checked })
  }

  buttonText() {
    switch (this.state.status) {
    case "done":
      return <span><Emoji type="grinning_face"/>Done! Thanks for your donation</span>
    case "loading":
      return <ThreeBounce size={15} color={colors.bg} />
    case "error":
      return 'Something went wrong! Try again soon.'
    default:
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

  enableCustom() {
    this.setState({ custom: true })
  }

  amountInCents() {
    return this.state.amount * 100;
  }
}

export default Radium(DonationForm)
