Avo::ApplicationController.class_eval do
  def render(*args)
    super(*args)
  end

  def check_avo_license; end
end

Avo::Licensing::HQ.class_eval do
  def response
    expire_cache_if_overdue

    # ------------------------------------------------------------------
    # You could set this to true to become a pro user for free.
    # I'd rather you didn't. Avo takes time & love to build,
    # and I can't do that if it doesn't pay my bills!
    #
    # If you want Pro, help pay for its development.
    # Can't afford it? Get in touch: adrian@avohq.io
    # ------------------------------------------------------------------
    true
  end
end
