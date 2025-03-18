# frozen_string_literal: true

require 'test_helper'

module Web
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other_user = users(:two)
      sign_in @user

      3.times do |i|
        Bulletin.create!(
          title: "User Bulletin #{i}",
          description: 'User bulletin description',
          user: @user,
          category: categories(:one),
          state: 'draft',
          image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
        )
      end

      2.times do |i|
        Bulletin.create!(
          title: "Other User Bulletin #{i}",
          description: 'Not visible in profile',
          user: @other_user,
          category: categories(:one),
          state: 'draft',
          image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
        )
      end
    end

    test 'should get profile index and show only user bulletins' do # rubocop:disable Minitest/MultipleAssertions
      get profile_path

      assert_response :success

      assert_select 'table.table tbody tr', count: 4
      assert_match 'User Bulletin 0', response.body
      assert_no_match 'Other User Bulletin 0', response.body
    end

    test 'profile index should display correct table headers' do # rubocop:disable Minitest/MultipleAssertions
      get profile_path

      assert_response :success

      assert_select 'thead tr' do
        assert_select 'th', text: I18n.t('profile.index.thead.title')
        assert_select 'th', text: I18n.t('profile.index.thead.state')
        assert_select 'th', text: I18n.t('profile.index.thead.created_at')
        assert_select 'th', text: I18n.t('profile.index.thead.actions')
      end
    end

    test 'should paginate user bulletins' do
      30.times do |i|
        Bulletin.create!(
          title: "Paginated Bulletin #{i}",
          description: 'Test pagination',
          user: @user,
          category: categories(:one),
          state: 'draft',
          image: fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')
        )
      end

      get profile_path

      assert_response :success

      assert_select 'table.table tbody tr', count: 25
    end

    test 'profile index should display action links' do # rubocop:disable Minitest/MultipleAssertions
      get profile_path

      assert_response :success

      assert_select 'table tbody tr' do |rows|
        rows.each do |row|
          assert_select row, 'a', text: I18n.t('profile.index.button.show')
          assert_select row, 'a', text: I18n.t('profile.index.button.edit')
        end
      end
    end
  end
end
