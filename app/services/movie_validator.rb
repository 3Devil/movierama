# Mimics ActiveModel::Validator (to an extent)
class MovieValidator
  def initialize(movie)
    @movie = movie
    @errors = nil
  end

  def valid?
    errors.empty?
  end

  def errors
    return @errors if @errors
    @errors = {}

    if @movie.title.blank?
      @errors[:title] = true
    end

    if @movie.description.blank?
      @errors[:description] = true
    end

    if @movie.date.blank?
      @errors[:date] = true
    end

    @errors
  end

  def class_for(field)
    errors[field] ? "has-error" : ""
  end
end
