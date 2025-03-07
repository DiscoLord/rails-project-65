# frozen_string_literal: true

require 'test_helper'

class BulletinPolicyTest < ActiveSupport::TestCase
  test 'user cannot index' do
    assert_not BulletinPolicy.new(@user, @bulletin).index?
  end

  test 'admin can index' do
    assert_predicate BulletinPolicy.new(@admin, @bulletin), :index?
  end

  test 'guest cannot new' do
    assert_not BulletinPolicy.new(@guest, @bulletin).new?
  end

  test 'user can new' do
    assert_predicate BulletinPolicy.new(@user, @bulletin), :new?
  end

  test 'guest cannot create' do
    assert_not BulletinPolicy.new(@guest, @bulletin).create?
  end

  test 'user can create' do
    assert_predicate BulletinPolicy.new(@user, @bulletin), :create?
  end

  test 'guest cannot edit' do
    assert_not BulletinPolicy.new(@guest, @bulletin).edit?
  end

  test 'user can edit' do
    assert_predicate BulletinPolicy.new(@user, @bulletin), :edit?
  end

  test 'guest cannot update' do
    assert_not BulletinPolicy.new(@guest, @bulletin).update?
  end

  test 'user can update' do
    assert_predicate BulletinPolicy.new(@user, @bulletin), :update?
  end

  test 'guest cannot send_to_moderation' do
    assert_not BulletinPolicy.new(@guest, @bulletin).send_to_moderation?
  end

  test 'user can send_to_moderation' do
    assert_predicate BulletinPolicy.new(@user, @bulletin), :send_to_moderation?
  end

  test 'guest cannot archive' do
    assert_not BulletinPolicy.new(@guest, @bulletin).archive?
  end

  test 'user can archive' do
    assert_predicate BulletinPolicy.new(@user, @bulletin), :archive?
  end

  test 'user cannot reject' do
    assert_not BulletinPolicy.new(@user, @bulletin).rejected?
  end

  test 'admin can reject' do
    assert_predicate BulletinPolicy.new(@admin, @bulletin), :rejected?
  end

  test 'user cannot publish' do
    assert_not BulletinPolicy.new(@user, @bulletin).published?
  end

  test 'admin can publish' do
    assert_predicate BulletinPolicy.new(@admin, @bulletin), :published?
  end
end
