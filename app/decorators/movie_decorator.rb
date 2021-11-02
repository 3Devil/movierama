class MovieDecorator < Draper::Decorator
  delegate_all

  def has_votes?
    object.likers.any? || object.haters.any?
  end

  def count_likers
    object.likers.size
  end

  def count_haters
    object.haters.size
  end

  def date
    Date.parse(object.date).to_s(:long)
  end
end
