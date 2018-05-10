# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::WorkshopFeedbacks', type: :request do
  describe 'POST /v1/workshop_feedbacks' do
    let(:params) { {} } # override in subtests

    before do
      # wrap in perform_enqueued_jobs so the job to send out the notification
      # email is ran so we can test that the admin notification was actually
      # queued
      perform_enqueued_jobs do
        post '/v1/workshop_feedbacks', params: params
      end
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

        # queues email
        expect(WorkshopFeedbackMailer.deliveries.length).to eq(1)
      end
    end
  end
end
