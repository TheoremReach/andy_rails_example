class Utility::ValidUrl
  attr_reader :url, :body,  :secret

  def initialize(url: nil, body: nil,  secret: nil)
    @url = url
    @body = body
    @secret = secret
  end

  def ex
    raise "No secret key provided" if secret.blank?

    return false if url.blank?
    

    return provided_hash.eql? generated_hash
  end

  def body_without_hash
    body
  end

  def generated_hash
    Utility::EncryptUrl.new(
      url: url_without_hash,
      body: body_without_hash,
      secret: secret
    ).secret_hash
  end

  def provided_hash
    # enc in the the GET params
    if url.include? 'enc='
      return CGI.parse(url.split('?')[1])['enc'][0]
    end

    # enc not in get params and body is blank, so not in post
    return nil if body.blank?

    begin
      return JSON.parse(body)['enc']
    rescue
      return nil
    end
  end

  def url_without_hash
    return url unless url.include? 'enc=' 

    hash_removed_url = url.split(/&?enc\=[A-Za-z0-9\-\_]+/).join()

    if hash_removed_url[-1].eql? '?'
      return hash_removed_url[0..-2]
    end

    return hash_removed_url
  end
end
