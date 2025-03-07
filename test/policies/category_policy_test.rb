# frozen_string_literal: true

require 'test_helper'

class CategoryPolicyTest < ActiveSupport::TestCase
  test 'admin can access index category' do
    assert_predicate CategoryPolicy.new(@admin, Category.new), :index?
  end

  test 'user cannot access index category' do
    assert_not CategoryPolicy.new(@user, Category.new).index?
  end

  test 'admin can access new category' do
    assert_predicate CategoryPolicy.new(@admin, Category.new), :new?
  end

  test 'user cannot access new category' do
    assert_not CategoryPolicy.new(@user, Category.new).new?
  end

  test 'admin can access create category' do
    assert_predicate CategoryPolicy.new(@admin, Category.new), :create?
  end

  test 'user cannot access create category' do
    assert_not CategoryPolicy.new(@user, Category.new).create?
  end

  test 'admin can access edit category' do
    assert_predicate CategoryPolicy.new(@admin, categories(:one)), :edit?
  end

  test 'user cannot access edit category' do
    assert_not CategoryPolicy.new(@user, categories(:one)).edit?
  end

  test 'admin can access update category' do
    assert_predicate CategoryPolicy.new(@admin, categories(:one)), :update?
  end

  test 'user cannot access update category' do
    assert_not CategoryPolicy.new(@user, categories(:one)).update?
  end

  test 'admin can access destroy category' do
    assert_predicate CategoryPolicy.new(@admin, categories(:one)), :destroy?
  end

  test 'user cannot access destroy category' do
    assert_not CategoryPolicy.new(@user, categories(:one)).destroy?
  end
end
