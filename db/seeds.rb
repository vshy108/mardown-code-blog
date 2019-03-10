unless User.exists?
  puts 'Seed user'
  User.create! email: 'admin@test.com',
               password: 'admin123', password_confirmation: 'admin123'
end

unless Blog.exists?
  puts 'Seed blogs'
  Blog.create! user: User.first, status: 'draft', tags: ['ruby'],
               content: "
```ruby
class Service
  def initialize(object:)
    @object = object
  end

  def call
    object.id
  end

  private

  attr_reader :object
end
```
               "
end
