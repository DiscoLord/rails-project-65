# frozen_string_literal: true

require 'test_helper'

class BulletinTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @category = categories(:one)
  end

  test 'should not be valid without a title' do
    bulletin = Bulletin.new(title: nil, description: 'Valid Description', user: @user, category: @category)

    assert_not bulletin.valid?
  end

  test 'should not be valid with a title that is too short' do
    bulletin = Bulletin.new(title: 'A', description: 'Valid Description', user: @user, category: @category)

    assert_not bulletin.valid?
  end

  test 'should not be valid with a title that is too long' do
    bulletin = Bulletin.new(title: 'A' * 51, description: 'Valid Description', user: @user, category: @category)

    assert_not bulletin.valid?
  end

  test 'should not be valid without a description' do
    bulletin = Bulletin.new(title: 'Valid Title', description: nil, user: @user, category: @category)

    assert_not bulletin.valid?
  end

  test 'should not be valid with a description that is too long' do
    bulletin = Bulletin.new(title: 'Valid Title', description: 'A' * 1001, user: @user, category: @category)

    assert_not bulletin.valid?
  end

  test 'should not be valid without a category' do
    bulletin = Bulletin.new(title: 'Valid Title', description: 'Valid Description', user: @user, category: nil)

    assert_not bulletin.valid?
  end

  test 'should not be valid with an oversized image' do
    bulletin = Bulletin.new(title: 'Valid Title', description: 'Valid Description', user: @user, category: @category)
    bulletin.image.attach(io: File.open('test/fixtures/files/large_image.png'), filename: 'large_image.png',
                          content_type: 'image/pmg')

    assert_not bulletin.valid?
  end

  test 'should not be valid with an unsupported image format' do
    bulletin = Bulletin.new(title: 'Valid Title', description: 'Valid Description', user: @user, category: @category)
    bulletin.image.attach(io: File.open('test/fixtures/files/test.txt'),
                          filename: 'test.txt', content_type: 'text/plain')

    assert_not bulletin.valid?
  end
end
