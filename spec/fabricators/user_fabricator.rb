Fabricator(:user) do 
	full_name {sequence(:full_name) {Faker::Name.name }}
	email {sequence(:email) { |n| "#{Faker::Internet.email}{n}@example.com"} }
	password {sequence(:password) {Faker::Internet.password}}
end