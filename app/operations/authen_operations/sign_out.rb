module AuthenOperations
  class SignOut < BaseOperation
    def initialize(params = {})
      @params = params
    end

    def execute
      session = Session.find_by(token: @params[:session_token])

      return { success: false } if session.nil?

      session.update!(revoked_at: Time.current)

      { success: true }
    end
  end
end