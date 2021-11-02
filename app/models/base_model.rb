require 'ohm'
require 'ohm/contrib'

class BaseModel < Ohm::Model
  def to_param
    id
  end
end
