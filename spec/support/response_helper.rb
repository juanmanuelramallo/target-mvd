module ResponseHelper
  def json_response
    JSON.parse(response.body)
  end

  def data(response = @response)
    json_response["data"]
  end

  def errors(response = @response)
    json_response["errors"]
  end
end
