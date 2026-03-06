class ApplicationController < ActionController::API
    include ActionController::Cookies 

    rescue_from StandardError, with: :render_500
    rescue_from ActiveModel::ValidationError, with: :render_422
    rescue_from ActionController::ParameterMissing, with: :render_400

    def render_success_response(option = { })
        render json: {
            status: "success"
        }.merge!(data: option)
    end

    def render_failed_response(option = { })
        render json: {
            status: "failed"
        }.merge!(data: option)
    end

    def action_response(is_success, option = { })
        return render_success_response(option) if is_success

        render_failed_response(option)
    end

    def render_500
        render json: {
            status: 'failed',
            message: 'Internal server error'
        }, status: 500
    end

    def render_422(error)
        render json: {
            status: 'failed',
            errors: error.model.errors.to_hash
        }, status: 422
    end

    def render_400(error)
        render json: {
            status: 'failed',
            message: error.message
        }, status: 400
    end

    def validate!(param_class)
        attribute_keys = param_class.attribute_names.map(&:to_s)

        permitted_params = params.permit(attribute_keys).to_h

        param_object = param_class.new(permitted_params)

        raise ActiveModel::ValidationError, param_object unless param_object.valid?

        param_object.attributes.symbolize_keys
    end

    def current_user
        @current_user ||= Session.find_by(token: cookies.signed[:session_token])&.user
    end

    def require_auth!
        return if current_user

        render json: { error: "Unauthorized" }, status: :unauthorized
    end
end
