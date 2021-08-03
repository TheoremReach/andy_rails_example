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
    valid_url_hash = Utility::ValidUrl.new(
      url: request.original_url,
      body: body,
      secret: "d9ba573850d34067307c751a216e747c1d6367a138ff136362b843975a38c16aac34"
    )

    hash_is_valid = valid_url_hash.ex
    return true if hash_is_valid

    Rails.logger.error("Request contains an invalid security hash.  url=#{request.original_url} body=#{valid_url_hash.body_without_hash} provided_hash=#{valid_url_hash.provided_hash} expected_hash=#{valid_url_hash.generated_hash}")
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

  
end