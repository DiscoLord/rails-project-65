# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'valid category' do
    category = Category.new(name: 'test')

    assert_predicate category, :valid?
  end

  test 'invalid category' do
    category = Category.new(name: '')

    assert_not category.valid?
  end
end
