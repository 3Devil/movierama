class MoviesController < ApplicationController
  def index
    # TODO: extract loginc into a Search service
    if _index_params[:user_id]
      @submitter = User[_index_params[:user_id]]
      scope = Movie.find(user_id: @submitter.id).to_a
    elsif _index_params[:filter_by] && current_user
      @filter_by = _index_params[:filter_by]
      scope = @filter_by == 'like' ? Movie.liked_by(current_user.uid) : Movie.hated_by(current_user.uid)
    else
      scope = Movie.all.to_a
    end

    @movies = case _index_params.fetch(:by, 'likers')
              when 'likers'
                scope.sort_by { |m| m.liker_count.to_i }.reverse
              when 'haters'
                scope.sort_by { |m| m.hater_count.to_i }.reverse
              when 'date'
                scope.sort_by(&:created_at).reverse
              else
                scope
              end
  end

  def new
    authorize! :create, Movie

    @movie = Movie.new
    @validator = NullValidator.instance
  end

  def create
    authorize! :create, Movie

    attrs = _create_params.merge(user: current_user)
    @movie = Movie.new(attrs)
    @validator = MovieValidator.new(@movie)

    if @validator.valid?
      @movie.save
      flash[:notice] = "Movie added"
      redirect_to root_url
    else
      flash[:error] = "Errors were detected"
      render 'new'
    end
  end

  private

  def _index_params
    params.permit(:by, :user_id, :filter_by)
  end

  def _create_params
    params.permit(:title, :description, :date)
  end
end
