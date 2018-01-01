# frozen_string_literal: true

Stripe.api_key = Rails.application.secrets.stripe_secret_key
