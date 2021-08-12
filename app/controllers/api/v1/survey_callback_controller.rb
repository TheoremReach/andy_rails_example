class Api::V1::SurveyCallbackController < Api::V1::ApiController
  skip_before_action :verify_security_hashing!
  #before_filter :intercept_html_requests

  def create
    Rails.logger.info { "#{self.class.name} - params: #{params}" }

    render json: {}, status: :ok
  end
end
