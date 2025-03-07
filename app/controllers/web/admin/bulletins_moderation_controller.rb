# frozen_string_literal: true

module Web
  module Admin
    class BulletinsModerationController < ApplicationController
      def index
        authorize Bulletin
        @bulletins = Bulletin.under_moderation
      end
    end
  end
end
