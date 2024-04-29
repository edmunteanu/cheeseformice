# frozen_string_literal: true

FactoryBot.define do
  factory :update_log do
    status { :finished }
    created_at { Time.current }
    completed_at { Time.current }
  end
end
