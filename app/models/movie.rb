class Movie < BaseModel
  include Ohm::Timestamps

  attribute :title
  index :title
  attribute :date
  attribute :description

  reference :user, :User

  attribute :liker_count
  attribute :hater_count

  set :likers, :User
  set :haters, :User

  def self.liked_by(uid)
    Movie.all.select { |mv| mv.likers.any? { |u| u.uid == uid } }
  end

  def self.hated_by(uid)
    Movie.all.select { |mv| mv.haters.any? { |u| u.uid == uid } }
  end
end
