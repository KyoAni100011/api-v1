module Api
  module V1
    module Auth
      class AuthenController < ApplicationController
        def login
          params = validate!(LoginParam)

          result = AuthenOperations::SignIn.execute(params.merge(
            ip_address: request.remote_ip,
            user_agent: request.user_agent
          ))

          if result[:success]
            cookies.signed[:session_token] = {
              value: result[:data][:token],
              httponly: true,
              secure: Rails.env.production?,
              expires: 30.days.from_now,
              same_site: :lax
            }

            return render_success_response(data: result[:data].except(:token))
          end

          render_failed_response
        end

        def register
          params = validate!(RegisterParam)

          result = AuthenOperations::SignUp.execute(params)

          if result[:success]
            cookies.signed[:session_token] = {
              value: result[:data][:token],
              httponly: true,
              secure: Rails.env.production?,
              expires: 30.days.from_now,
              same_site: :lax
            }

            return render_success_response(data: result[:data].except(:token))
          end

          render_failed_response
        end

        def me
          result = AuthenOperations::Me.execute(session_token: cookies.signed[:session_token])

          return render_success_response(result[:data]) if result[:success]

          render_failed_response
        end

        def logout
          result = AuthenOperations::SignOut.execute(
            session_token: cookies.signed[:session_token]
          )

          if result[:success]
            cookies.delete(:session_token)
            return render_success_response
          end

          render_failed_response
        end
      end
    end
  end
end