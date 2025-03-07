# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      include AASM
      before_action :set_bulletin, except: :index

      def index
        authorize Bulletin
        @bulletins = Bulletin.includes(:user).order(created_at: :desc)
      end

      def published
        authorize @bulletin
        @bulletin.approve!
        redirect_to request.url, notice: I18n.t('shared.bulletin.flash.notice.publish')
      end

      def rejected
        authorize @bulletin
        @bulletin.reject!
        redirect_to request.url, notice: I18n.t('shared.bulletin.flash.notice.reject')
      end

      def archive
        authorize @bulletin
        @bulletin.archive!
        redirect_to request.url, notice: I18n.t('shared.bulletin.flash.notice.archive')
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end
    end
  end
end
