class Api::V1::ApiController < ApplicationController
  #respond_to :json  
  #protect_from_forgery with: :null_session
  before_action :verify_security_hashing!
  
  private

  # def restrict_access    

  #   if params[:api_key].blank? || params[:api_key].to_s != "12372358972485724895789237523533"
  #     self.__send__ :render, :json => { :error => "Access denied. You did not provide an api key." }.to_json, :status => :unauthorized
  #     return false
  #   end  
  #   return true
  # end

  def verify_security_hashing!
    # only request body hashing if we're working with json
    body = if request.form_data? then nil else request.body.read end
    
    Rails.logger.error("BODY: #{body}")
    Rails.logger.error("Params Data: #{params.permit(:data).to_json}")
    Rails.logger.error("Original url: #{request.original_url}")

    valid_url_hash = Utility::ValidUrl.new(
      url: request.original_url,
      body: params.permit(:data).to_json,
      secret: "caf536d72a7db63fe0499638fcd91a946cf181c132b6d5b41cfaaf11234143d2"
    )

    hash_is_valid = valid_url_hash.ex
    return true if hash_is_valid

    Rails.logger.error("Request contains an invalid security hash.  url=#{request.original_url} params=#{params[:data]} orig_body_class=#{request.body.class} body=#{valid_url_hash.body_without_hash} provided_hash=#{valid_url_hash.provided_hash} expected_hash=#{valid_url_hash.generated_hash}")
    add_hint 'See our request hashing docs here: https://docs.userwise.io/#request-hashing-required'
    return render_error(
      errors: ['Security request hash verification failed.'],
      status: :forbidden
    )
  end

  #####################
  ## Request Metadata
  #####################
  
  def warnings; @warnings || [] end
  def warnings=(warnings); @warnings = warnings end
  def add_warning(warning); @warnings = warnings << warning end

  def hints; @hints || [] end
  def hints=(hints); @hints = hints end
  def add_hint(hint); @hints = hints << hint end
  ############
  ## Renderers
  ############

  def render_error(errors: [], status: :bad_request, **params)
    errors = [errors] unless errors.is_a? Array

    begin
      # errors.each do |error|
      #   UserWise::LogError.new().log!(error: error, company: current_company, app: current_app)
      # end
    # rescue => ex
    #   Rails.logger.error("#{self.class.name} - Error - #{ex.message}")
    #   Rollbar.error(ex)
    end

    return render(
      json: { errors: errors, data: {}, meta: { warnings: warnings, hints: hints } },
      status: status,
      adapter: :json,
      **params
    )
  end

  def render_success(data: {}, status: :ok, **params)
    metadata = { warnings: warnings, hints: hints }
    metadata[:query] = params[:query_meta] if params[:query_meta]

    return render(
      json: data,
      meta: metadata,
      root: 'data', 
      status: status,
      adapter: :json,
      **params
    )
  end
  
end