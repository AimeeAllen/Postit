class CategoriesController < ApplicationController
before_action :write_access, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(name: params[:id])
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
