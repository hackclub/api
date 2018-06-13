# frozen_string_literal: true

# DotTechClient provides a convenient way to submit requests for .TECH domains.
#
# For most partnerships, .TECH requires users to go to their website and go
# through a complex process to request a free domain. This class manually
# submits that form for our users so we can provide a more convenient method for
# redeeming domains.
module DotTechClient
  class << self
    BASE_URL = 'http://get.tech'
    USER_AGENT = 'Hack Club API'

    # .TECH uses some sort of form generator on their site and these parameters
    # are included on every manual request for a new .TECH domain.
    DEFAULT_FORM_DATA = {
      iphorm_id: '6',
      iphorm_uid: '57212e5ea7534',
      form_url: 'http://get.tech/startups/',
      post_id: '6637',
      post_title: 'Startups',
      iphorm_ajax: '1',
      iphorm_6_0: ''
    }.freeze

    COMPANY_NAME = 'Hack Club'

    def request_domain(person_name, person_email, requested_domain)
      params = DEFAULT_FORM_DATA.merge(
        iphorm_6_1: person_name,
        iphorm_6_2: person_email,
        iphorm_6_3: COMPANY_NAME,
        iphorm_6_4: requested_domain
      )

      request(:post, '/startups/', params)
    end

    private

    def request(method, path, payload)
      RestClient::Request.execute(
        method: method,
        url: BASE_URL + path,
        payload: payload,
        headers: {
          'User-Agent' => USER_AGENT
        }
      )
    end
  end
end
