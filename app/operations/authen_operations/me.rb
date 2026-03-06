module AuthenOperations
    class Me < BaseOperation
        def initialize(params = { })
            @params = params
        end

        def execute
            session = Session.find_by(token: @params[:session_token])

            return { success: false } if session.nil?
            return { success: false } if session.expires_at < Time.current
            return { success: false } if session.revoked_at.present?

            user = session.user

            {
                success: true,
                data: {
                    username: user.name,
                    email: user.email
                }
            }

        end
    end
end