# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email+#{n}@example.com" }
    password { Faker::Internet.password(min_length: 12, mix_case: true, special_characters: true) }
  end
end
