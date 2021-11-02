class MoviesController < ApplicationController
  def index
    # TODO: extract loginc into a Search service
    if _index_params[:user_id]
      @submitter = User[_index_params[:user_id]]
      scope = Movie.find(user_id: @submitter.id)
    else
      scope = Movie.all
    end

    @movies = case _index_params.fetch(:by, 'likers')
    when 'likers'
      scope.sort(by: 'Movie:*->liker_count', order: 'DESC')
    when 'haters'
      scope.sort(by: 'Movie:*->hater_count', order: 'DESC')
    when 'date'
      scope.sort(by: 'Movie:*->created_at',  order: 'DESC')
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
    params.permit(:by, :user_id)
  end

  def _create_params
    params.permit(:title, :description, :date)
  end
end
