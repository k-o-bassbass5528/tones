class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]

  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8).reverse_order
    @followingUsers = @user.following_user
    @followerUsers = @user.follower_user
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    @isRoom = false
    @roomId = nil
    @room = Room.new
    @entry = Entry.new

    if @user.id == current_user.id
      # 自分のプロフィールページの場合の処理
      @posts = @user.posts.page(params[:page]).per(8).reverse_order
    else
      @posts = @user.posts.page(params[:page]).per(8).reverse_order.where(status: "published")
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(5).reverse_order
  end

  def destroy
    @user = User.find(params[:id]) 
    @user.destroy
    flash[:notice] = '退会しました。ご利用ありがとうございました。'
    redirect_to :root
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end

