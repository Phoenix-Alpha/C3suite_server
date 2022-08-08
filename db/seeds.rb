# Roles
role_names = ['Admin', 'Product Manager', 'Content Contributor', 'Instructor', 'Customer']

role_names.each do |name|
  role = Role.find_or_create_by name: name

  # Add user for each role
  username = name.downcase.split(' ').last
  if role.present?
    user = User.find_by_username username

    User.create! username: username, email: "#{username}@code3apps.com", password: 'code3apps', password_confirmation: 'code3apps', roles: [role] unless user.present?
  end
  # ------------------------ #


end

product = Product.find_or_create_by(title: 'EMT Tutor', visibility: 'All', price: 0.0)
quizzes = Modulee.create(title: 'Quizzes', product: product)
flashcards = Modulee.create(title: 'Flashcards', product: product)

# run the following after running > rake db:seed
# rake import:quizzes
# rake import:flashcards
