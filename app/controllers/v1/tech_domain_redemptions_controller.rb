# frozen_string_literal: true

module V1
  class TechDomainRedemptionsController < ApiController
    # TODO: Move logic for secret code to model
    SECRET_CODE = Rails.application.secrets.tech_domain_redemption_secret_code

    def create
      redemption = TechDomainRedemption.new(redemption_params)

      if redemption.valid? && !secret_code_errors && redemption.save
        render_success(redemption)
      else
        errors = {}.merge(redemption.errors || {})
                   .merge(secret_code_errors || {})
        render_field_errors(errors)
      end
    end

    private

    def secret_code_errors
      errors = { secret_code: [] }

      errors[:secret_code].push "can't be blank" if secret_code.nil?
      errors[:secret_code].push 'invalid' if secret_code != SECRET_CODE

      return nil if errors[:secret_code].count.zero?

      errors
    end

    def redemption_params
      params.permit(
        :name,
        :email,
        :requested_domain
      )
    end

    def secret_code
      params[:secret_code]
    end
  end
end
