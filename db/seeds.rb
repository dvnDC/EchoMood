roles = ['admin', 'regular', 'cool', 'research_participant']

roles.each do |role_name|
  Role.find_or_create_by(name: role_name)
end

admin = User.find_or_create_by(nickname: 'admin') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

admin.add_role('admin')
