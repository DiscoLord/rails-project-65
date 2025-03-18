# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
    setup do
      @user = users(:one)
      @category = categories(:one)
      sign_in @user

      @bulletin = Bulletin.create!(
        title: 'My Bulletin',
        description: 'Test description',
        user: @user,
        category: @category,
        state: 'draft',
        image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
      )
    end

    test 'should get index and show only published bulletins' do
      published_bulletin = Bulletin.create!(
        title: 'Published Bulletin',
        description: 'Visible in index',
        user: @user,
        category: @category,
        state: 'published',
        image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
      )

      get bulletins_path

      assert_response :success

      puts response.body unless response.body.include?(published_bulletin.title)

      assert_match published_bulletin.title, response.body
    end

    test 'should show bulletin' do
      @bulletin.image.attach(
        io: Rails.root.join('test/fixtures/files/test_image.png').open,
        filename: 'test_image.png',
        content_type: 'image/png'
      )

      get bulletin_path(@bulletin)

      assert_response :success
      assert_select 'h1', @bulletin.user.name
    end

    test 'should get new if logged in' do
      get new_bulletin_path

      assert_response :success
    end

    test 'guest cannot access new' do
      begin
        delete logout_path
      rescue StandardError
        OmniAuth.config.mock_auth[:github] = nil
      end
      get new_bulletin_path

      assert_redirected_to root_path
    end

    test 'should create bulletin' do
      params = {
        bulletin: {
          title: 'New Bulletin',
          description: 'Description',
          category_id: @category.id,
          image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
        }
      }

      assert_difference('Bulletin.count', 1) do
        post bulletins_path, params: params
      end

      assert_redirected_to profile_path
    end

    test 'should not create bulletin with invalid data' do
      params = {
        bulletin: {
          title: '',
          description: '',
          category_id: nil,
          image: nil
        }
      }

      assert_no_difference('Bulletin.count') do
        post bulletins_path, params: params
      end

      assert_response :unprocessable_entity
    end

    test 'should get edit if user owns the bulletin' do
      get edit_bulletin_path(@bulletin)

      assert_response :success
    end

    test 'user can update their own bulletin' do
      patch bulletin_path(@bulletin), params: {
        bulletin: {
          title: 'Updated Title',
          description: 'Updated Description',
          image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
        }
      }

      assert_redirected_to profile_path
      @bulletin.reload

      assert_equal 'Updated Title', @bulletin.title
    end

    test 'should not update bulletin with invalid data' do
      patch bulletin_path(@bulletin), params: { bulletin: { title: '' } }

      assert_response :unprocessable_entity
    end

    test 'user can send their bulletin to moderation' do
      @bulletin.update!(
        state: 'draft',
        image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
      )

      patch send_to_moderation_bulletin_path(@bulletin)

      assert_redirected_to profile_path

      @bulletin.reload

      assert_equal 'under_moderation', @bulletin.state, "Expected bulletin to be in 'under_moderation' state"
    end

    test 'user can archive their bulletin' do
      @bulletin.update!(
        state: 'published',
        image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
      )

      patch archive_bulletin_path(@bulletin)

      assert_redirected_to profile_path

      @bulletin.reload

      assert_equal 'archived', @bulletin.state, "Expected bulletin to be in 'archived' state"
    end
  end
end
