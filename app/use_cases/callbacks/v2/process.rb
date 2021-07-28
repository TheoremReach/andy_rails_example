#Callbacks::V2::Process.new(params: {url: "https://theoremreach.com/app_testing", data: {test: "testo"}, method: "post"}).ex
#Callbacks::V2::Process.new(params: {url: "https://kubigo.pl/82apis11/theorm.php?user_id=5&app_id=13079&reward=45&status=1&currency=0.5&screenout=2&profiler=2&tx_id=66144ca7-e6bd-4d67-95c7-5e60e9f4b9c6&debug=true&hash=mPKoeXAizRpRM9B7mIhuhH0U9sM"}).v1
require 'net/http'

class Callbacks::V2::Process
  
  attr_reader :params

  def initialize(params: params_in)
    @params = params
  end

  def ex    
    #ap params
    begin
      if params[:method] == "post"
        return post
      elsif params[:method] == "put"
        return put
      else
        raise "GET Not Implemented V2"
        return get
      end
      
    # rescue RestClient::Forbidden => ex
    #   return {error: ex, code: 404}
    # rescue RestClient::OpenTimeout => ex
    #   return {error: ex, code: 404}
    rescue => ex
      #Rollbar.error(ex, params: params)
      Rails.logger.error {"Error on callback Attempt V2: #{ex.message} - #{params[:url]} - version"}
      return {error: ex.message, code: 404, location: "Callbacks::V2::Process - Rescue"}
    end
  end

  def post
    Rails.logger.info {"V2 POST - #{url} -- Attempting Payload: #{params[:data]}"}
    data = params[:data].to_h.dup
    response = RestClient::Request.execute(method: :post, 
      url: params[:url],
      payload: data,
      timeout: 10)
    Rails.logger.info {"V2 POST - #{params[:url]} - #{response.body.to_s.first(500)} - #{response.code}"}
    case response.code
    when 200      
      return {status: "ok", code: 200}
    else
      return {error: "Invalid Response Code", code: response.code }
    end    
  end
  def put
    Rails.logger.info {"V2 PUT - #{url} -- Attempting"}
    response = RestClient::Request.execute(method: :put, 
      url: params[:url],
      payload: params[:data],
      timeout: 10)
    Rails.logger.info {"V2 PUT - #{params[:url]} - #{response.body.to_s.first(500)} - #{response.code}"}
    case response.code
    when 200      
      return {status: "ok", code: 200}
    else
      return {error: "Invalid Response Code", code: response.code }
    end    
  end
  def url
    params[:url]
  end

end
