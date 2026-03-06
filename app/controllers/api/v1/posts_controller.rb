module Api
  module V1
    class PostsController < ApplicationController
      before_action :require_auth!

      def index
        posts = PostOperations::GetPosts.execute()

        render_success_response(posts)
      end

      def create
        params = validate!(PostParam)

        post = PostOperations::CreatePost.execute(current_user, params)

        render_success_response(post)
      end
    end
  end
end