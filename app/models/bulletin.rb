# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :category
  belongs_to :user

  has_one_attached :image
  include ImageValidations

  validates :category_id, numericality: { only_integer: true }
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, presence: true

  aasm column: 'state' do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :rejected
    state :archived

    event :submit do
      transitions from: :draft, to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft published rejected under_moderation], to: :archived
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title category_id state]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category]
  end

  def state_label
    I18n.t("activerecord.attributes.bulletin.state.#{aasm.current_state}")
  end
end
