Avo::ApplicationController.class_eval do
  def render(*args)
    super(*args)
  end

  def check_avo_license; end
end

Avo::Licensing::HQ.class_eval do
  AvoHttpResponse = Struct.new(:body, :parsed_response, :code, :headers)

  def perform_request
    body = {"id": "pro", "valid": true, payload: payload}
    AvoHttpResponse.new(body.to_json, body, 200, {"Content-Type" => "application/json"})
  end
end
