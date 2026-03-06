module PostOperations
  class CreatePost < BaseOperation
    def initialize(user, params)
        @user = user
        @params = params
    end

    def execute
      Post.create!(
        user: @user,
        content: @params[:content],
        image_url: @params[:image_url]
      )
    end
  end
end