# frozen_string_literal: true

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    test 'create bulletin' do
      bulletin = Bulletin.new(
        title: 'title',
        description: 'description',
        user: @user,
        category: @category
      )

      bulletin.image.attach(
        io: Rails.root.join('test/fixtures/files/test_image.png').open,
        filename: 'test_image.png',
        content_type: 'image/jpg'
      )
      bulletin.save

      bulletins = Bulletin.where(title: 'title')

      assert_equal 1, bulletins.count
    end

    test 'unauthorized user cannot create bulletin' do
      bulletin = Bulletin.new(
        title: 'title',
        description: 'description',
        user: @guest,
        category: @category
      )

      bulletin.image.attach(
        io: Rails.root.join('test/fixtures/files/test_image.png').open,
        filename: 'test_image.png',
        content_type: 'image/jpg'
      )
      bulletin.save

      bulletins = Bulletin.where(title: 'title')

      assert_equal 0, bulletins.count
    end

    test 'guest cannot update bulletin' do
      @bulletin.image.attach(
        io: Rails.root.join('test/fixtures/files/test_image.png').open,
        filename: 'test_image.png',
        content_type: 'image/jpg'
      )
      bulletin = @bulletin.update(
        title: 'up title',
        description: 'description',
        user: @guest,
        category: @category
      )

      assert_not bulletin
    end

    test 'user can update bulletin' do
      @bulletin.image.attach(
        io: Rails.root.join('test/fixtures/files/test_image.png').open,
        filename: 'test_image.png',
        content_type: 'image/jpg'
      )
      bulletin = @bulletin.update(
        title: 'up title',
        description: 'description',
        user: @user,
        category: @category
      )

      assert bulletin
    end
  end
end
