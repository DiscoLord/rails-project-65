# frozen_string_literal: true

module Web
  class BulletinsController < Web::ApplicationController
    include AuthenticationConcern
    include AASM

    before_action :set_bulletin, only: %i[send_to_moderation archive]
    before_action :authenticate_user!, only: %i[new create edit update]

    def index
      authorize Bulletin
      @q = Bulletin.ransack(params[:q])
      @bulletins = @q.result(distinct: true).includes(:user).published.order(created_at: :desc)
    end

    def show
      @bulletin = Bulletin.find(params[:id])
    end

    def new
      @bulletin = Bulletin.new
      @categories = Category.all
    end

    def edit
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
      @categories = Category.all
    end

    def create
      authorize Bulletin
      @bulletin = Bulletin.new(bulletin_params)
      @bulletin.user = current_user
      @categories = Category.all

      if @bulletin.save
        redirect_to @bulletin, notice: I18n.t('shared.bulletin.flash.notice')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @categories = Category.all
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin

      if @bulletin.update(bulletin_params)
        redirect_to profile_path, notice: I18n.t('shared.bulletin.flash.update')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def send_to_moderation
      authorize @bulletin
      @bulletin.submit!
      redirect_to profile_path, notice: I18n.t('shared.bulletin.flash.notice.send_to_moderation')
    end

    def archive
      authorize @bulletin
      @bulletin.archive!
      redirect_to profile_path, notice: I18n.t('shared.bulletin.flash.notice.archive')
    end

    private

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end
  end
end
