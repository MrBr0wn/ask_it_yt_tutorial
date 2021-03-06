# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Rails.env.production?
  # clear db
  Question.destroy_all
  User.destroy_all
  Tag.destroy_all

  # Creating 30 something questions
  30.times do
    title = Faker::Hipster.sentence(word_count: 3)
    body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)

    Question.create(title:, body:)
  end

  # default demo user
  User.create!(
    email: 'demo@example.com',
    name: 'demo',
    password: 'Qwerty-123',
    password_confirmation: 'Qwerty-123'
  )

  # Set up avatar for each User
  # User.find_each do |user|
  #   user.send(:set_gravatar_hash)
  #   user.save
  # end

  # Generating random Tags
  30.times do
    title = Faker::Hipster.word
    Tag.create(title:)
  end
end
