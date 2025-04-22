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
  
    # フリーワード検索
    if params[:search].present?
      @posts = @posts.where('instrument LIKE ?', "%#{params[:search]}%")
    end
  
    # カテゴリ検索（"全て"はID=0として無視）
    if params[:category_id].present? && params[:category_id].to_i != 0
      @posts = @posts.where(category_id: params[:category_id])
    end
  
    # カテゴリ一覧（検索時は"全て"も含める）
    @categories = Category.all.to_a
    @categories.unshift(Category.new(id: 0, name: "全て"))
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
  
    # 新しい画像があるか確認（ないなら無視）
    if params[:post][:images].present?
      if @post.update(post_params)
        redirect_to post_path(@post.id)
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # 画像フィールド空のままなら、画像以外だけ更新
      if @post.update(post_params.except(:images))
        redirect_to post_path(@post.id)
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end
  
  

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def confirm
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
  
    # フリーワード検索
    if params[:search].present?
      @posts = @posts.where('instrument LIKE ?', "%#{params[:search]}%")
    end
  
    # カテゴリ検索（"全て"はID=0として無視）
    if params[:category_id].present? && params[:category_id].to_i != 0
      @posts = @posts.where(category_id: params[:category_id])
    end
  
    # カテゴリ一覧（検索フォーム用に"全て"を追加）
    @categories = Category.all.to_a
    @categories.unshift(Category.new(id: 0, name: "全て"))
  end
  
  def image_urls
    post = Post.find(params[:id])
    render json: post.images.map { |img| url_for(img) }
  end

  private
  def post_params
    params.require(:post).permit(:user_id, :instrument, :text, :status, :category_id, images: [])
  end
end