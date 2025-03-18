# frozen_string_literal: true

module Web
  module Admin
    class BulletinsControllerTest < ActionDispatch::IntegrationTest
      test 'admin can publish bulletin' do
        sign_in @admin
        @bulletin = bulletins(:one) # Ensure bulletin is initialized

        @bulletin.image.attach(
          io: Rails.root.join('test/fixtures/files/test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/jpg'
        )

        @bulletin.update!(state: 'under_moderation') # Ensure valid state transition

        patch publish_admin_bulletin_url(@bulletin)

        assert_redirected_to request.url
        assert_equal I18n.t('shared.bulletin.flash.category.notice.publish'), flash[:notice]

        @bulletin.reload

        assert_predicate @bulletin, :published?
      end

      test 'admin cannot publish bulletin in invalid state' do
        sign_in @admin
        @bulletin = bulletins(:one)

        @bulletin.image.attach(
          io: Rails.root.join('test/fixtures/files/test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/jpg'
        )

        @bulletin.update!(state: 'published') # Already published

        patch publish_admin_bulletin_url(@bulletin)

        assert_redirected_to request.url
        assert_equal I18n.t('controllers.errors'), flash[:notice]

        @bulletin.reload

        assert_predicate @bulletin, :published?
      end

      test 'admin can reject bulletin' do
        sign_in @admin
        @bulletin = bulletins(:one)

        @bulletin.image.attach(
          io: Rails.root.join('test/fixtures/files/test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/jpg'
        )

        @bulletin.update!(state: 'under_moderation')

        patch reject_admin_bulletin_url(@bulletin)

        assert_redirected_to request.url
        assert_equal I18n.t('shared.bulletin.flash.category.notice.reject'), flash[:notice]

        @bulletin.reload

        assert_predicate @bulletin, :rejected?
      end

      test 'admin cannot reject bulletin in invalid state' do
        sign_in @admin
        @bulletin = bulletins(:one)

        @bulletin.image.attach(
          io: Rails.root.join('test/fixtures/files/test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/jpg'
        )

        @bulletin.update!(state: 'published')

        patch reject_admin_bulletin_url(@bulletin)

        assert_redirected_to request.url
        assert_equal I18n.t('controllers.errors'), flash[:notice]

        @bulletin.reload

        assert_predicate @bulletin, :published?
      end

      test 'admin can archive bulletin' do
        sign_in @admin
        @bulletin = bulletins(:one)

        @bulletin.image.attach(
          io: Rails.root.join('test/fixtures/files/test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/jpg'
        )

        @bulletin.update!(state: 'published')

        patch archive_admin_bulletin_url(@bulletin)

        assert_redirected_to request.url
        assert_equal I18n.t('shared.bulletin.flash.category.notice.archive'), flash[:notice]

        @bulletin.reload

        assert_predicate @bulletin, :archived?
      end

      test 'non-admin user cannot publish bulletin' do
        sign_in @admin
        @bulletin = bulletins(:one)

        @bulletin.image.attach(
          io: Rails.root.join('test/fixtures/files/test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/jpg'
        )

        @bulletin.update!(state: 'under_moderation') # Ensure valid state transition

        sign_in @user # Switch to a non-admin user

        patch publish_admin_bulletin_url(@bulletin)

        assert_response :redirect # Expect 302 Found
        follow_redirect!

        assert_response :success # Ensure redirected page loads correctly

        assert_equal I18n.t('shared.flash.not_admin'), flash[:alert]
      end
    end
  end
end
