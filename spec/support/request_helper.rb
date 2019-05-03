module RequestHelper
  def headers
    user.create_new_auth_token
  end
end
