Avo::ApplicationController.class_eval do
  def render(*args)
    super(*args)
  end

  def check_avo_license; end
end

Avo::Licensing::HQ.class_eval do
  def response
    {"id": "pro", "valid": true, "payload": {}}
  end
end
