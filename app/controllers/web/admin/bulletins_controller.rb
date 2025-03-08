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
        template = params[:template].in?(ALLOWED_TEMPLATES) ? params[:template] : 'index'
        render action: template
      end

      def publish
        authorize @bulletin
        if @bulletin.may_publish?
          @bulletin.publish!
          redirect_to request.url, notice: I18n.t('shared.bulletin.flash.category.notice.publish')
        else
          redirect_to request.url, notice: I18n.t('controllers.errors')
        end
      end

      def reject
        authorize @bulletin

        if @bulletin.may_reject?
          @bulletin.reject!
          redirect_to request.url, notice: I18n.t('shared.bulletin.flash.category.notice.reject')
        else
          redirect_to request.url, notice: I18n.t('controllers.errors')
        end
      end

      def archive
        authorize @bulletin
        if @bulletin.may_archive?
          @bulletin.archive!
          redirect_to request.url, notice: I18n.t('shared.bulletin.flash.category.notice.archive')
        else
          redirect_to request.url, notice: I18n.t('controllers.errors')
        end
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end
    end
  end
end
