# frozen_string_literal: true

module V1
  module NewClubs
    class InformationVerificationRequestsController < ApiController
      include UserAuth

      def verify
        req = ::NewClubs::InformationVerificationRequest.find(params_id)
        authorize req

        req.verified_at = Time.current
        req.verifier = current_user

        if req.save
          render_success req
        else
          render_field_errors req.errors
        end
      end

      private

      def params_id
        params[:information_verification_request_id]
      end
    end
  end
end
