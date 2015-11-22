class CategoriesController < ApplicationController
  before_action only: [:new, :create] do 
    allow_access('admin')
  end

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(slug: params[:id])
    @posts = @category.posts.limit(Post::POSTS_PER_PAGE).offset(params[:offset])
    @post_pages = (@category.posts.size.to_f / Post::POSTS_PER_PAGE).ceil
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "New category created"
      redirect_to categories_path
    else
      render 'new'
    end
  end

  private
  def category_params
    params.require(:category).permit!
  end

end
