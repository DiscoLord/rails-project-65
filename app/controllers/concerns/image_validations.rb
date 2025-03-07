# frozen_string_literal: true

module ImageValidations
  extend ActiveSupport::Concern

  included do
    validate :validate_image
  end

  private

  def validate_image
    if image.attached?
      allowed_types = %w[image/jpeg image/png]
      unless allowed_types.include?(image.content_type)
        errors.add(:image, I18n.t('errors.messages.bulletin.image_type'))
      end

      max_size = 5.megabytes
      if image.byte_size > max_size
        errors.add(:image, I18n.t('errors.messages.bulletin.image_size'), max_size: max_size)
      end
    else
      errors.add(:image, I18n.t('errors.messages.bulletin.image'))
    end
  end
end
