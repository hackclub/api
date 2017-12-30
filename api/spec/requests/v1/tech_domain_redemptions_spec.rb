# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'V1::TechDomainRedemptions', type: :request, vcr: true do
  describe 'POST /v1/tech_domain_redemptions' do
    SECRET_CODE = Rails.application.secrets.tech_domain_redemption_secret_code

    let(:redemption_attrs) { attributes_for(:tech_domain_redemption) }
    let(:attrs_to_send) { redemption_attrs.merge(secret_code: SECRET_CODE) }

    context 'with valid attributes' do
      it 'returns a new TechDomainRedemption' do
        post '/v1/tech_domain_redemptions', params: attrs_to_send

        expect(response.status).to eq(200)

        # Make sure all redemption attrs sent are present in response
        redemption_attrs.each do |name, val|
          expect(json[name.to_s]).to eq(val)
        end

        expect(json['id']).to_not be(nil)
        expect(json['created_at']).to_not be(nil)
        expect(json['updated_at']).to_not be(nil)
      end

      it "POSTs to .TECH's servers" do
        expect(DotTechClient).to receive(:request_domain).with(
          redemption_attrs[:name],
          redemption_attrs[:email],
          redemption_attrs[:requested_domain]
        )

        post '/v1/tech_domain_redemptions', params: attrs_to_send
      end
    end

    context 'with invalid attributes' do
      context 'without a secret code' do
        before { attrs_to_send.delete(:secret_code) }

        it 'returns an error' do
          post '/v1/tech_domain_redemptions', params: attrs_to_send

          expect(response.status).to eq(422)
          expect(json['errors']['secret_code']).to include("can't be blank")
        end
      end

      context 'with an invalid secret code' do
        before { attrs_to_send[:secret_code] = 'invalid' }

        it 'returns an error' do
          post '/v1/tech_domain_redemptions', params: attrs_to_send

          expect(response.status).to eq(422)
          expect(json['errors']['secret_code']).to include('invalid')
        end
      end

      context 'without a name' do
        before { attrs_to_send.delete(:name) }

        it 'returns an error' do
          post '/v1/tech_domain_redemptions', params: attrs_to_send

          expect(response.status).to eq(422)
          expect(json['errors']['name']).to include("can't be blank")
        end
      end

      context 'with an invalid email' do
        before { attrs_to_send[:email] = 'not an email' }

        it 'returns an error' do
          post '/v1/tech_domain_redemptions', params: attrs_to_send

          expect(response.status).to eq(422)
          expect(json['errors']['email']).to include('is not an email')
        end
      end
    end
  end
end
