class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.published.page(params[:page]).reverse_order
    @posts = @posts.where('instrument LIKE ?', "%#{params[:search]}%") if params[:search].present?
    @posts = @posts.where(category_id: params[:category_id]) if params[:category_id].present?
    @categories = Category.all
  end

  def show
    @post = Post.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, post_id: @post.id)
      current_user.view_counts.create(post_id: @post.id)
    end
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if params[:post][:images].present?
      # 新しい画像が追加された場合のみ、既存の画像を保持
      if @post.update(post_params)
        redirect_to post_path(@post.id)
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # 画像が変更されていない場合は、画像パラメータを除外して更新
      if @post.update(post_params.except(:images))
        redirect_to post_path(@post.id)
      else
        render :edit, status: :unprocessable_entity
      end
    end
    # 画像を削除する場合の処理
    if params[:post][:images_to_remove]
      @post.images.purge
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def confirm
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
  end

  private
  def post_params
    params.require(:post).permit(:user_id, :instrument, :text, :status, :category_id, images: [])
  end
end