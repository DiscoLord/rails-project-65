# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @category = categories(:one)
      sign_in @user
    end

    test 'should create bulletin' do
      params = {
        bulletin: {
          title: 'New Bulletin',
          description: 'Description',
          category_id: @category.id,
          image: fixture_file_upload(
            Rails.root.join('test/fixtures/files/test_image.png'), 'image/png'
          )
        }
      }

      post bulletins_path, params: params

      new_bulletin = Bulletin.find_by(title: 'New Bulletin', description: 'Description', user: @user)

      assert new_bulletin
    end

    test 'unauthorized user cannot create bulletin' do
      begin
        delete logout_path
      rescue StandardError
        OmniAuth.config.mock_auth[:github] = nil
      end

      params = {
        bulletin: {
          title: 'Unauthorized Bulletin',
          description: 'Should not exist',
          category_id: @category.id,
          image: fixture_file_upload(
            Rails.root.join('test/fixtures/files/test_image.png'), 'image/png'
          )
        }
      }

      post bulletins_path, params: params

      unauthorized_bulletin = Bulletin.find_by(title: 'Unauthorized Bulletin')

      assert_nil unauthorized_bulletin
      assert_redirected_to root_path
    end

    test 'guest cannot update bulletin' do
      bulletin = bulletins(:one)

      patch bulletin_path(bulletin), params: {
        bulletin: { title: 'Updated Title' }
      }

      bulletin.reload

      assert_not_equal 'Updated Title', bulletin.title
    end

    test 'user can update their own bulletin' do
      bulletin = Bulletin.create!(
        title: 'User Bulletin',
        description: 'Test description',
        user: @user,
        category: @category,
        state: 'draft',
        image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
      )

      patch bulletin_path(bulletin), params: {
        bulletin: { title: 'Updated Title' }
      }

      bulletin.reload

      assert_equal 'Updated Title', bulletin.title
    end
  end
end
