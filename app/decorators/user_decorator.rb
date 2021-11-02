class UserDecorator < Draper::Decorator
  delegate_all

  def likes?(movie)
    movie.likers.include?(object)
  end

  def hates?(movie)
    movie.haters.include?(object)
  end
end

