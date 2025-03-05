# frozen_string_literal: true

module Web
  class AuthController < ApplicationController

    def callback
      auth_data = request.env['omniauth.auth']
      user = User.find_or_initialize_by(email: auth_data['info']['email'])
      user.name = auth_data['info']['name'] || user.name
      user.save!
      session[:user_id] = user.id
      redirect_to root_path, notice: "Добро пожаловать, #{user.name}!"

    rescue StandardError => e
      redirect_to root_path, alert: "Ошибка входа: #{e.message}"
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: 'Вы вышли.'
    end
  end
end