#Utility::EncryptUrl.new(hash_method: "sha3",url: "http://google.com", secret: "123").ex
#Utility::EncryptUrl.new(hash_method: "enc_sha3",url: "http://lvh.me:3000/respondent_entry?api_key=907794f0-3443-4341-8533-03784213d11d&suid=4227f4b0-3920-41a4-bf32-b13e7b4294e5&quid=c5641ed3-5a2c-40cd-abe2-ab96211d4e20&user_id=adamtest&transaction_id=transactionId1&test=true", secret: RespondentSource.first.secret_key).ex

class Utility::EncryptUrl
  attr_reader :url, :body, :secret, :hash_param_name
  
  def initialize(url: nil, body: nil, secret: nil, **args)

    @url = url 
    @body = body
    @secret = secret
    @hash_param_name = hash_param_name || "enc"
  end

  def ex
    return url if secret.blank?

    symb = if url.include?("?")
      "&"
    else
      "?"
    end
    
    return url + "#{symb}#{hash_param_name}=#{secret_hash}"
  end

  def secret_url
    return '' if url.blank?
    return '' if secret.blank?

    unless body.blank?
      url + body + secret
    else
      url + secret
    end
  end

  def secret_hash

    SHA3::Digest.hexdigest :sha256, secret_url
  end
end
