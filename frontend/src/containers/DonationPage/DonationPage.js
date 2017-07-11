import React, { Component } from 'react'
import Radium from 'radium'
import { ThreeBounce } from 'better-react-spinkit'
import Helmet from 'react-helmet'
import { NavBar, Header, Heading, Button, Card, HorizontalRule, Emoji } from '../../components'

import { mediaQueries } from '../../styles/common'
import colors from '../../styles/colors'

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
  donateButton: {
    marginTop: '30px'
  },
  rule: {
    marginBottom: '20px',
    marginTop: '10px'
  }
}

class Cards extends React.Component {
  constructor(props) {
    super(props);

    console.log(props)

    this.state = {
      loading: true,
      stripeLoading: true,
      amount: 25,
      recurring: false
    };
    // onStripeUpdate must be bound or else clicking on button will produce error.
    this.onStripeUpdate = this.onStripeUpdate.bind(this);
    // binding loadStripe as a best practice, not doing so does not seem to cause error.
    this.loadStripe = this.loadStripe.bind(this);
    this.handleAmountChange = this.handleAmountChange.bind(this);
    this.handleRecurringChange = this.handleRecurringChange.bind(this)
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
        key: 'pk_test_yw3YYp18HpZD1j0sR4un7h2N',
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

          fetch('http://localhost:3000/v1/donations', {method: 'post', body: data })
            .then(resp => {
              return resp.json()
            }).then(data => {
              if (data.donation_successful) {
                console.log(data)

                this.setState({status: 'done'})
              }
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
    } else {
      return `Donate $${this.state.amount}!`
    }
  }

  render() {
    const { stripeLoading, loading } = this.state;
    return (
      <div>
        <label htmlFor="amount">Amount</label>
        <input name="amount" type="number" value={this.state.amount} onChange={this.handleAmountChange} style={styles.input} min="1" step="1"/>
        <br />

        <label htmlFor="recurring">Monthly payment?</label>
        <input name="recurring" type="checkbox" value={this.state.recurring} onChange={this.handleRecurringChange} />
        <br />

        <Button style={styles.donateButton} onClick={this.pay} type='link'>{this.buttonText()}</Button>
      </div>
    );
  }
}

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

          <Cards/>
        </Card>
      </div>
    )
  }
}

export default Radium(Donations)
