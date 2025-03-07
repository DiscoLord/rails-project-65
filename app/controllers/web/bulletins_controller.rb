# frozen_string_literal: true

module Web
  class BulletinsController < Web::ApplicationController
    include AuthenticationConcern
    before_action :authenticate_user!, only: %i[new create]

    def index
      @bulletins = Bulletin.includes(:user).order(created_at: :desc)
    end

    def show
      @bulletin = Bulletin.find(params[:id])
    end

    def new
      @bulletin = Bulletin.new
      @categories = Category.all
    end

    def create
      @bulletin = Bulletin.new(bulletin_params)
      @bulletin.user = current_user
      @categories = Category.all

      if @bulletin.save
        redirect_to @bulletin, notice: I18n.t('shared.bulletin.flash.notice')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
