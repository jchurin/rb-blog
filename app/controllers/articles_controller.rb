class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, except: %i[index new create]
  before_action :authenticate_editor!, only: %i[new create update]
  before_action :authenticate_admin!, only: [:destroy]

  # GET '/articles'
  def index
    @articles = Article.paginate(page: params[:page], per_page: 5).publisheds.latests
  end

  # GET '/articles/:id'
  def show
    @article.update_visits_count
    @comment = Comment.new
  end

  # GET '/articles/new'
  def new
    @article = Article.new
  end

  # POST '/articles'
  def create
    @article = current_user.articles.new(article_params)
    @article.categories = params[:categories]
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  # PUT '/articles/:id/edit'
  def edit; end

  # PUT '/articles/:id'
  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  # DELETE '/articles/:id'
  def destroy
    redirect_to @article if @article.destroy
  end

  def publish
    @article.publish!
    redirect_to @article
  end

  def unpublish
    @article.unpublish!
    redirect_to @article
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :cover, :categories, :markup_body)
  end
end
