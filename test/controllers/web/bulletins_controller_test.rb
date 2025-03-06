# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers

    test 'should get index' do
      get bulletins_url

      assert_response :success
    end

    # test 'should get new' do
    #   get new_bulletin_url

    #   assert_response :success
    # end

    # test 'should get create' do
    #   post bulletin_url

    #   assert_response :success
    # end
  end
end
