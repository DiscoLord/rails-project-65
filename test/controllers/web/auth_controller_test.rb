# frozen_string_literal: true

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers

    test 'check github auth' do
      post auth_request_path('github')

      assert_response :redirect
    end

    test 'create' do
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: Faker::Internet.email,
          name: Faker::Name.first_name
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')

      assert_response :redirect

      user = User.find_by(email: auth_hash[:info][:email].downcase)

      assert user
      assert_predicate self, :signed_in?
    end
  end
end
