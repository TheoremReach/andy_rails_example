class StaticController < ApplicationController
  
  def health_check
    render plain: "A OK", status: 200
  end

end
