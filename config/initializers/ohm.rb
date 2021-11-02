require 'ohm'

Ohm.redis = Redic.new(ENV.fetch('DB_URL'))
