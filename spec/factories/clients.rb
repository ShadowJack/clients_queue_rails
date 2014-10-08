# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    operation "MyString"
    start 1
    length 1
    finish 1
    window "MyString"
  end
end
