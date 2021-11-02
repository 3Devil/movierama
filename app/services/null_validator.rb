# A validator that always passes and has no errors.
class NullValidator
  include Singleton

  def valid?
    true
  end

  def errors
    {}
  end

  def class_for(field)
    ""
  end
end

