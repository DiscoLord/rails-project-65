# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    test 'create bulletin' do
      bulletin = Bulletin.new(
        title: 'title',
        description: 'description',
        user: users(:one),
        category: categories(:one)
      )

      bulletin.image.attach(
        io: Rails.root.join('test/fixtures/files/test_image.png').open,
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      bulletin.save

      bulletins = Bulletin.where(title: 'title')

      assert_equal 1, bulletins.count
    end

    test 'unauthorized user cannot create bulletin' do
      bulletin = Bulletin.new(
        title: 'title',
        description: 'description',
        user: nil,
        category: categories(:one)
      )

      bulletin.image.attach(
        io: Rails.root.join('test/fixtures/files/test_image.png').open,
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      bulletin.save

      bulletins = Bulletin.where(title: 'title')

      assert_equal 0, bulletins.count
    end
  end
end
