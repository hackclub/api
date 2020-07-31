# frozen_string_literal: true

# this is tested in spec/controllers/v1/concerns/
module UserAuth
  extend ActiveSupport::Concern

  included do |base|
    params = base.const_defined?('USER_AUTH') &&
             base.const_get('USER_AUTH').dup # dup bc constants are frozen

    if params
      before_action :authenticate_user, params
    else
      before_action :authenticate_user
    end
  end

  def authenticate_user
    auth_header = request.headers['Authorization']
    return render_unauthenticated unless auth_header

    _auth_type, auth_token = auth_header.split(' ')
    return render_invalid_authorization unless auth_token

    @user = User.find_by(auth_token: auth_token)

    if @user
      unless @user.auth_token_generation > (Time.current - 30.days)
        return render_error('auth token expired', 401)
      end

      # all clear! authed & ready to go.
    else
      render_invalid_authorization
    end
  end

  def current_user
    @user
  end

  protected

  def render_unauthenticated
    render_error('authorization required', 401)
  end

  def render_invalid_authorization
    render_error('authorization invalid', 401)
  end
end
