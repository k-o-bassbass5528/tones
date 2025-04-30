class RoomsController < ApplicationController
    before_action :authenticate_user!

    def index
        @rooms = current_user.rooms.includes(:messages).order('messages.created_at DESC').page(params[:page]).per(5)
    end

    def create
        @room = Room.create(user_id: current_user.id)
        @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
        @entry2 = Entry.create(entry_params)
        redirect_to room_path(@room.id, page: 1)
    end

    def show
        @room = Room.find(params[:id])
        if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
            @messages = @room.messages.order(created_at: :desc).page(params[:page]).per(7)
            @message = Message.new
            @entries = @room.entries
            @myUserId = current_user.id
        else
            redirect_back(fallback_location: root_path)
        end
    end

    private
    def entry_params
        params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
    end
end
