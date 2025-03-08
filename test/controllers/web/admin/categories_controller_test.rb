# frozen_string_literal: true

module Admin
  module Web
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      test 'create category' do
        Category.create(name: 'test')
        category = Category.where(name: 'test')

        assert_equal 1, category.count
      end

      test 'update category' do
        category = Category.create(name: 'test')

        assert_equal 'test', category.name

        category.update(name: 'test2')

        assert_equal 'test2', category.reload.name
      end

      test 'destroy category' do
        category = Category.create(name: 'test')

        assert_equal 3, Category.count

        category.destroy

        assert_equal 2, Category.count
      end

      test 'admin can access categories index' do
        sign_in @admin
        get admin_categories_path

        assert_response :success
      end

      test 'user cannot access categories index' do
        sign_in @user
        get admin_categories_path

        assert_redirected_to root_path
      end

      test 'admin can access categories new' do
        sign_in @admin
        get new_admin_category_path

        assert_response :success
      end

      test 'user cannot access categories new' do
        sign_in @user
        get new_admin_category_path

        assert_redirected_to root_path
      end

      test 'admin can access categories edit' do
        sign_in @admin
        get edit_admin_category_path(@category)

        assert_response :success
      end

      test 'user cannot access categories edit' do
        sign_in @user
        get edit_admin_category_path(@category)

        assert_redirected_to root_path
      end

      test 'admin can access categories destroy' do
        sign_in @admin
        delete admin_category_path(@category)

        assert_redirected_to admin_categories_path
      end

      test 'user cannot access categories destroy' do
        sign_in @user
        delete admin_category_path(@category)

        assert_redirected_to root_path
      end
    end
  end
end
