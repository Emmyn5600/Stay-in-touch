class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: %i[create destroy]

  def create
    if @friendship.nil?
      @friend_request = Friendship.new(user_id: current_user.id, friend_id: params[:id])
      if @friend_request.save
        @friend_request.pending!
        flash[:notice] = 'Friend Request Sent!'
      else
        flash[:alert] = 'Something Went Wrong!'
      end
    else
      flash[:notice] = 'Sorry! there is already a friend request pending with this user!'
    end

    redirect_to request.referer
  end

  def update
    @friend_request = Friendship.find_by(user_id: params[:id], friend_id: current_user.id)
    @friend_request.confirmed! if @friend_request.pending?
    @friend_request.confirm_friend
    redirect_to request.referer
  rescue StandardError
    flash[:alert] = 'Something Went Wrong!'
    redirect_to request.referer
  end

  def destroy
    redirect_to request.referer if @friendship.destroy
  rescue StandardError
    flash[:alert] = 'Something Went Wrong!'
    redirect_to request.referer
  end

  private

  def set_friendship
    @friendship = Friendship.find_by(user_id: params[:id], friend_id: current_user.id) ||
                  Friendship.find_by(user_id: current_user.id, friend_id: params[:id])
  end
end
