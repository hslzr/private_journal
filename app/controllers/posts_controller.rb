class PostsController < ApplicationController
  before_action :find_post, only: [:edit, :show, :update, :destroy]

  def index
    @posts_exist = Post.count > 0
    @posts = Post.includes(:tags).order(created_at: :desc).has_tag(params[:search]).paginate(params[:page])
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def show
  end

  def create
    @post = PostManager.create(params[:title], params[:content], tags_param)

    if !@post.new_record?
      flash[:success] = "Entry saved"
      redirect_to posts_path
    else
      flash.now[:error] = @post.errors.full_messages.join(", ")
      render :new
    end
  end

  def update
    if PostManager.update(@post, params[:title], params[:content], tags_param)
      flash[:success] = "Entry saved"
      redirect_to post_path(@post)
    else
      flash.now[:error] = @post.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Entry deleted"
    else
      flash[:error] = "Issue deleting entry"
    end

    redirect_to posts_path
  end

  private

  def tags_param
    params[:tags].split(",").map(&:strip).reject { |t| t.blank? }
  end

  def find_post
    @post = Post.find_by_id(params[:id])

    if !@post
      flash[:error] = "Entry is missing"
      redirect_to posts_path and return
    end
  end
end
