# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < Web::Admin::ApplicationController
      before_action :find_category, only: %i[edit update destroy]

      def index
        authorize Category
        @categories = Category.all
      end

      def new
        authorize Category
        @category = Category.new
      end

      def edit; end

      def create
        authorize Category
        @category = Category.new(category_params)

        if @category.save
          redirect_to categories_path, notice: I18n.t('shared.category.flash.notice.create')
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          redirect_to categories_path, notice: I18n.t('shared.category.flash.notice.update')
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @category.destroy
        redirect_to categories_path, notice: I18n.t('shared.category.flash.notice.delete')
      end

      private

      def find_category
        @category = Category.find(params[:id])
        authorize @category
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
