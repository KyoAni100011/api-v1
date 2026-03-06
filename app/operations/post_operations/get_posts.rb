module PostOperations
  class GetPosts < BaseOperation
    def execute
      Post.includes(:user).order(created_at: :desc)
    end
  end
end