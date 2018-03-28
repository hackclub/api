# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::WorkshopFeedbacks', type: :request do
  describe 'POST /v1/workshop_feedbacks' do
    let(:params) { {} } # override in subtests

    before do
      post '/v1/workshop_feedbacks', params: params
    end

    it 'fails gracefully' do
      expect(response.status).to eq(422)
      expect(json['errors']['workshop_slug']).to include("can't be blank")
    end

    context 'with valid params' do
      let(:params) do
        {
          workshop_slug: 'personal_website',
          feedback: {
            "What'd you think of the workshop?": 'Loved it!',
            "Any other thoughts?": 'Nope!'
          }
        }
      end

      it 'succeeds' do
        expect(response.status).to eq(201)
        expect(json['id']).to be_present
      end
    end
  end
end
