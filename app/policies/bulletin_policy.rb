# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def new?
    user
  end

  def edit?
    record.user_id == user&.id
  end

  def create?
    user
  end

  def update?
    user
  end

  def send_to_moderation?
    record.user_id == user&.id
  end

  def publish?
    user.admin?
  end

  def reject?
    user.admin?
  end

  def archive?
    user&.admin? || record.user_id == user&.id
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
