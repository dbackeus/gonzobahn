def random_time
  Time.now.to_f
end

Factory.sequence :email do |n|
  "person#{random_time}@example.com"
end

Factory.sequence :login do |n|
  "user_#{random_time}"
end

Factory.define :user do |u|
  u.login { Factory.next :login }
  u.email { Factory.next :email }
  u.password "asdf"
  u.password_confirmation "asdf"
end

Factory.define :recording do |r|
  r.title "test"
  r.description "Omg..."
  r.filename "test.flv"
  r.length 45.345
  r.association :user
end