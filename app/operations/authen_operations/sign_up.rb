module AuthenOperations
    class SignUp < BaseOperation
        def initialize(params = { })
            @params = params
        end

        def execute
            return { success: false } if User.exists?(email: @params[:email])

            user = nil
            token = nil
            session = nil

            ActiveRecord::Base.transaction do
                user = User.create!(
                    name: @params[:name],
                    email: @params[:email],
                    password: @params[:password],
                    role: :user,
                    status: :active
                )

                session = Session.create!(
                    user: user,
                    token: SecureRandom.hex(32),
                    expires_at: 30.days.from_now,
                    ip_address: @params[:ip_address],
                    user_agent: @params[:user_agent]
                )
            end

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