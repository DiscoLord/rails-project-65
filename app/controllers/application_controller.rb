# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_admin

  private

  def user_not_admin
    redirect_to root_path, alert: I18n.t('shared.flash.not_admin')
  end
end
