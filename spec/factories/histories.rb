FactoryGirl.define do
  factory :history, class: History do
    sequence(:id) { |n| n  }
    sequence(:video_id) { |n| n }
    sequence(:keyword) { |n| "hogehoge#{n}" }
    user_id 1
  end

  factory :history4wrank, class: History do
    sequence(:id) { |n| n + 10_001_000 }
    sequence(:video_id) { |n| n + 10_002_000 }
    sequence(:keyword) { |n| "hogehoge#{n}" }
    sequence(:user_id) { |n| n }
  end

  factory :history4limit, class: History do
    sequence(:id) { |n| n + 30_001_000 }
    sequence(:video_id) { |n| n + 20_002_000 }
    sequence(:keyword) { |n| "hogehoge#{n}" }
  end
end
