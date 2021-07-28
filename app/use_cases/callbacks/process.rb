#Callbacks::Process.new(params: {url: "http://thesuperapps.in/SurveyCallbacks/theoream_callback.php"}).v2
#Callbacks::Process.new(params: {url: "https://kubigo.pl/82apis11/theorm.php?user_id=5&app_id=13079&reward=45&status=1&currency=0.5&screenout=2&profiler=2&tx_id=66144ca7-e6bd-4d67-95c7-5e60e9f4b9c6&debug=true&hash=mPKoeXAizRpRM9B7mIhuhH0U9sM"}).v1
require 'net/http'

class Callbacks::Process
  
  attr_reader :params

  def initialize(params: params_in)
    @params = params
  end

  def ex
    #ap params
    begin
      if version == 1
        v1
      elsif version == 2
        v2
      elsif version == 3
        v3
      else 
        v3
      end

    # rescue RestClient::Forbidden => ex
    #   return {error: ex, code: 404}
    # rescue RestClient::OpenTimeout => ex
    #   return {error: ex, code: 404}
    rescue => ex
      #Rollbar.error(ex, params: params)
      Rails.logger.error {"Error on callback Attempt: #{ex.message} - #{params[:url]} - version"}
      return {error: ex.message, code: 404, location: "Callbacks::Process - Rescue"}
    end
  end

  def v1
    Rails.logger.info {"V1 - #{url} -- Attempting"}
    response = RestClient::Request.execute(method: :get, 
      url: params[:url],
      timeout: 10)
    Rails.logger.info {"V1 - #{params[:url]} - #{response.body.to_s.first(500)} - #{response.code}"}
    case response.code
    when 200      
      return {status: "ok", code: 200}
    else
      return {error: "Invalid Response Code", code: response.code }
    end    
  end

  def v2
    Rails.logger.info {"V2 - #{url} - Attempting"}
    uri = URI(params[:url]) 
    # response = Net::HTTP.get_response(uri)

    http = Net::HTTP.new(uri.host, uri.port)

    http.read_timeout = 10
    http.open_timeout = 10
    
    response = http.start() {|http|
      http.get(uri.path)
    }
    
    Rails.logger.info {"V2 - #{params[:url]} - #{response.body.to_s.first(500)} - #{response.code}"}

    case response.code.to_i
    when 200      
      return {status: "ok", code: 200}
    else
      return {error: "Invalid Response Code", code: response.code }
    end    

  end

  def v3
    Rails.logger.info {"V3 - #{url} - Attempting"}
    response = HTTParty.get(params[:url])

    Rails.logger.info {"V3 - #{params[:url]} - #{response.body.to_s.first(500)} - #{response.code}"}

    case response.code.to_i
    when 200      
      return {status: "ok", code: 200}
    else
      return {error: "Invalid Response Code", code: response.code, error: response.body }
    end    

  end

  def version
    @version ||= (params[:version] || 1).to_i
  end

  def url
    params[:url]
  end

end
