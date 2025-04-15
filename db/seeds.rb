roles = ['admin', 'regular', 'cool']

roles.each do |role_name|
  Role.find_or_create_by(name: role_name)
end

# Dodaj admina
admin = User.find_or_create_by(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

admin.add_role('admin')
