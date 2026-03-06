users_data = [
  {
    name: "Admin User",
    email: "khaledmanga2003@gmail.com",
    password: "1234567890@Aa",
    role: "admin",
    status: "active"
  },
  {
    name: "Regular User",
    email: "hoangkhatruong2003@gmail.com",
    password: "1234567890@Aa",
    role: "user",
    status: "active"
  }
]

users = users_data.map do |user_attrs|
  password = user_attrs.delete(:password)

  user = User.find_or_initialize_by(email: user_attrs[:email])
  user.assign_attributes(user_attrs)
  user.password = password if user.new_record?
  user.save!

  user
end

admin = users[0]
user = users[1]

posts_data = [
  {
    user: admin,
    content: "Hello noop noop world!",
    image_url: "https://picsum.photos/400/300"
  },
  {
    user: user,
    content: "This is my first post",
    image_url: "https://picsum.photos/400/301"
  }
]

posts = posts_data.map do |attrs|
  Post.find_or_create_by!(
    user: attrs[:user],
    content: attrs[:content]
  ) do |post|
    post.image_url = attrs[:image_url]
  end
end

post1 = posts[0]
post2 = posts[1]


Comment.find_or_create_by!(
  user: user,
  post: post1,
  content: "Nice post!"
)

Comment.find_or_create_by!(
  user: admin,
  post: post2,
  content: "Welcome to the platform!"
)

Like.find_or_create_by!(user: admin, post: post2)
Like.find_or_create_by!(user: user, post: post1)
