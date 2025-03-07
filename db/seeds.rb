# frozen_string_literal: true

Rails.logger.debug 'Наполняем БД'

image_files = Dir['./public/images/*.{jpg,png}']
state = %w[draft published archived rejected under_moderation]

10.times do
  Category.create(name: Faker::Lorem.word)
end

t = rand(30..100)

t.times do
  user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
  File.open(image_files.sample, 'rb') do |image|
    category = Category.all.sample
    state_r = state.sample

    Bulletin.create!(title: Faker::Food.allergen, description: Faker::Food.description,
                     user: user, category: category, image: image, state: state_r)
  end
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error "Ошибка при создании пользователя или объявления: #{e.message}"
end

Rails.logger.debug 'БД наполнена'
