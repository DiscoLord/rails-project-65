# frozen_string_literal: true

image_files = Dir['./public/images/*.jpg']

5.times do
  user = User.create!(name: Faker::Name.name, email: Faker::Internet.email)
  category_name = Faker::Commerce.department(max: 1)
  category = Category.find_or_create_by!(name: category_name)
  image = File.open(image_files.sample)
  Bulletin.create(title: Faker::Lorem.sentence,
                  description: Faker::Lorem.paragraph,
                  user: user,
                  category: category,
                  image: image)
  image.close
end
