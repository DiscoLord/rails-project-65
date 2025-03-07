# frozen_string_literal: true

module Web
  module Admin
    class ApplicationController < Web::ApplicationController
      include AuthenticationConcern
      before_action :authenticate_user!
    end
  end
end
