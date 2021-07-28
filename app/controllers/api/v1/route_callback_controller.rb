class Api::V1::RouteCallbackController < Api::V1::ApiController
  #skip_before_action :verify_authenticity_token
  #before_filter :intercept_html_requests

  def create

    if params[:url].blank?
      Rails.logger.warn {"No URL Specified"}
      render json: {errors: ["No URL Specified"]}, status: :unprocessable_entity
      return
    end

    render json: Callbacks::Process.new(params: params.permit!).ex, status: 200

    # response = RestClient::Request.execute(method: :get, 
    #   url: params[:url],
    #   timeout: 10)
    # case response.code
    # when 200      
    #   render json: {status: "ok", code: 200}, status: 200  
    # else
    #   render json: {error: "Invalid Response Code", code: response.code }, status: 200
    # end
   
    # rescue => ex
    #   Rollbar.error(ex, params: params)
    #   render json: {error: ex, code: 404}, status: 200
  end

  def index
    render json: {error: "hi"}, status: 203
  end


end