class Api::V1::ApiController < ApplicationController
  #respond_to :json  
  #protect_from_forgery with: :null_session
  before_action :restrict_access
  
  private

  def restrict_access    

    if params[:api_key].blank? || params[:api_key].to_s != "12372358972485724895789237523533"
      self.__send__ :render, :json => { :error => "Access denied. You did not provide an api key." }.to_json, :status => :unauthorized
      return false
    end  
    return true
  end

end