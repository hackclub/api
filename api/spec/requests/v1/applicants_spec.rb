require 'rails_helper'

RSpec.describe 'V1::Applicants', type: :request do
  describe 'POST /v1/applicants/auth' do
    it 'fails with an invalid email' do
      post '/v1/applicants/auth', params: { email: 'bad_email' }

      expect(response.status).to eq(422)
      expect(json['errors']).to include('email')
    end

    it 'creates new object and sends email with new and valid email' do
      post '/v1/applicants/auth', params: { email: 'foo@bar.com' }

      expect(response.status).to eq(200)

      # return created object
      expect(json).to include('email' => 'foo@bar.com')
      expect(json).to include('id')
      expect(json).to include('created_at')
      expect(json).to include('updated_at')

      # but not secret fields
      expect(json).to_not include('auth_token')

      # creates applicant object w/ generated login code
      applicant = Applicant.last
      expect(applicant.email).to eq('foo@bar.com')
      expect(applicant.login_code).to match(/\d{6}/)

      # email queued to be sent
      expect(ApplicantMailer.deliveries.length).to be(1)
    end
  end

  it 'does not create object but sends login code with existing email' do
    # init applicant
    applicant = create(:applicant)
    applicant.generate_login_code
    applicant.save

    post '/v1/applicants/auth', params: { email: applicant.email }

    expect(response.status).to eq(200)

    # returns existing object
    expect(json).to include('email' => applicant.email)
    expect(json).to include('id' => applicant.id)

    # generates new login code
    expect(applicant.login_code).to_not eq(applicant.reload.login_code)

    # queued email
    expect(ApplicantMailer.deliveries.length).to be(1)
  end
end
