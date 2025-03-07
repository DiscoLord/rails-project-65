# frozen_string_literal: true

class Bulletin < ApplicationRecord
  has_one_attached :image
  include ImageValidations

  belongs_to :category
  belongs_to :user

  validates :category_id, numericality: { only_integer: true }
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, presence: true
end
