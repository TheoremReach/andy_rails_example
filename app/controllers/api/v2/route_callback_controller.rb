class Api::V2::RouteCallbackController < Api::V1::ApiController
  #skip_before_action :verify_authenticity_token
  #before_filter :intercept_html_requests

  def create

    if params[:url].blank?
      Rails.logger.warn {"No URL Specified"}
      render json: {errors: ["No URL Specified"]}, status: :unprocessable_entity
      return
    end

    render json: Callbacks::V2::Process.new(params: params.permit!).ex, status: 200

  end

  def index
    render json: {error: "hi"}, status: 203
  end


end