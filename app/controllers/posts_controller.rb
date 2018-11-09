class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :update, :show, :delete]
  before_action :authenticate_admin!, except: [:index, :show]
  # Index action to render all posts
  def index
    if params.has_key?(:category)
    # you can remove @category defining if you don't need it somewhere in view
    @category = Category.find_by_name(params[:category])
    @posts = Post.joins(:categories).where(categories: { name: params[:category] } ).order("created_at DESC").page(params[:page])
    else
    @posts = Post.order("created_at DESC").page(params[:page])
    end
    @posts = @posts.search(s_title: params[:s_title], s_category: params[:s_category]) if params[:s_title].present? || params[:s_category].present?
  end

  # New action for creating post
  def new
    @post = Post.new
  end

  # Create action saves the post into database
  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "Successfully created post!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Error creating new post!"
      render :new
    end
  end

  # Edit action retrives the post and renders the edit page
  def edit
  end

  # Update action updates the post with the new information
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:notice] = "Successfully updated post!"
      redirect_to posts_path(@posts)
    else
      flash[:alert] = "Error updating post!"
      render :edit
    end
  end

  # The show action renders the individual post after retrieving the the id
  def show 
  end


  # The destroy action removes the post permanently from the database
  def destroy
    @post = Post.find(params[:id])
    if @post.present?
       @post.destroy
      flash[:notice] = "Successfully deleted post!"
      redirect_to posts_path
    else
      flash[:alert] = "Error updating post!"
    end
  end

  private
  
  def post_params
    params.require(:post).permit(:title, :body, category_ids: [])
  end

  def find_post
    @post = Post.find(params[:id])
  end
end