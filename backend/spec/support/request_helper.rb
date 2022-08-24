module RequestHelper
  def json_body
    JSON.parse(response.body)
  end

  def access_denied_error
    [{ "errors" => ["Access Denied"] }, 405]
  end

  def unauthorised_error
    [{ "errors" => ["Access Denied"] }, 401]
  end

  def custom_error(err)
    [{ "errors" => err }, 422]
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
end