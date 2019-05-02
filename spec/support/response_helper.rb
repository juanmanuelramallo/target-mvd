module ResponseHelper
  def json_response
    JSON.parse(response.body)
  end

  def data
    json_response
  end

  def errors
    json_response['errors']
  end
end
