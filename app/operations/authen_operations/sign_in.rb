module AuthenOperations
    class SignIn < BaseOperation
        def initialize(params = { })
            @params = params
        end

        def execute
            user = User.find_by(email: @params[:email])

            return { success: false } if user.blank?
            
            return { success: false } unless user.authenticate(@params[:password])

            return { success: false } unless user.active?

            session = Session.create!(
                user: user,
                token: SecureRandom.hex(32),
                expires_at: 30.days.from_now,
                ip_address: @params[:ip_address],
                user_agent: @params[:user_agent]
            )

            {
                success: true,
                data: {
                    username: user.name,
                    email: user.email,
                    token: session.token
                }
            }

        end
    end
end