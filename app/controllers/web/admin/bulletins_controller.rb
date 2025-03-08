# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      include AASM
      before_action :set_bulletin, except: :index

      ALLOWED_TEMPLATES = %w[index moderation].freeze

      def index
        authorize Bulletin
        @q = Bulletin.ransack(params[:q])
        @bulletins = @q.result(distinct: true)
                       .includes(:user)
                       .order(created_at: :desc)
                       .page(params[:page])
                       .per(25)
        template = params[:template].in?(ALLOWED_TEMPLATES) ? params[:template] : :index
        render template
      end

      def published
        authorize @bulletin
        @bulletin.approve!
        redirect_to request.url, notice: I18n.t('shared.bulletin.flash.category.notice.publish')
      end

      def rejected
        authorize @bulletin
        @bulletin.reject!
        redirect_to request.url, notice: I18n.t('shared.bulletin.flash.category.notice.reject')
      end

      def archive
        authorize @bulletin
        @bulletin.archive!
        redirect_to request.url, notice: I18n.t('shared.bulletin.flash.category.notice.archive')
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end
    end
  end
end
