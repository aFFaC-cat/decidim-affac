# frozen_string_literal: true

if Rails.env.production?
  # Provided that trusted users use an HTTP request param named skip_rack_attack
  Rack::Attack.safelist("mark any authenticated access safe") do |request|
    # allow any number of requests for admin routes
    request.path.match? %r{^/admin/}
  end
end