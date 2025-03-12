# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth_data = request.env['omniauth.auth']
      user = User.find_or_initialize_by(email: auth_data['info']['email'])
      user.name = auth_data['info']['name'] || user.name
      user.save!
      session[:user_id] = user.id
      redirect_to root_path, notice: t('.welcome', name: user.name)
    # rescue StandardError => e
    #   redirect_to root_path, alert: t('.error', message: e.message)
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: t('.logged_out')
    end
  end
end
