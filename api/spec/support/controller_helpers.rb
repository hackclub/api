module Controllers
  module ControllerHelpers
    # copying this over from Requests::RequestHelpers
    def json
      @json || JSON.parse(response.body)
    end
  end
end
