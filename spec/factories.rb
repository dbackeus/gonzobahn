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
  r.association :user
end  

# Stub out the file handling things from recordings to allow them to be created without hassle
Recording.any_instance.stubs(:move_file_to_public_dir)
Recording.any_instance.stubs(:generate_thumbnail)
Recording.any_instance.stubs(:delete_files)