# frozen_string_literal: true

module Web
  class ProfileController < ApplicationController
    include AuthenticationConcern

    def index
      @bulletins = current_user.bulletins.order(created_at: :desc)
    end
  end
end
