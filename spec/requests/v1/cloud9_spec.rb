require 'rails_helper'

RSpec.describe 'V1::Cloud9', type: :request, vcr: true do
  describe 'POST /v1/cloud9/send_invite' do
    # Set email in the individual test contexts
    before { post '/v1/cloud9/send_invite', params: { email: email } }

    # Just a quick word of warning, this test case will be a little weird
    # because this set of tests uses VCR to cache responses. If you invalidate
    # the cache, this will probably fail because the given email has actually
    # probably already been sent an invite on Cloud9. This'll likely cause other
    # tests to fail too.
    #
    # You'll have to play around with the values we're submitting to get it working again.
    context 'with a valid email' do
      let(:email) { 'supervalid.and.superbad@example.com' }

      it 'succeeds' do
        expect(response.status).to eq(200)
        expect(json).to eq('success' => true)
      end
    end

    context 'with a duplicate email' do
      let(:email) { 'duplicate@example.com' }

      before { post '/v1/cloud9/send_invite', params: { email: email } }

      it 'errors' do
        expect(response).to have_http_status(409)
        expect(json['errors']['email']).to eq('Invite already sent for this email')
      end
    end

    context 'with an invalid email' do
      let(:email) { 'asdf' }

      it 'errors' do
        expect(response).to have_http_status(422)
        expect(json['errors']['email']).to eq('Must be a valid email')
      end
    end
  end
end
