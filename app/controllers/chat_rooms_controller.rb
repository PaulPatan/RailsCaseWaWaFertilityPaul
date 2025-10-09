class ChatRoomsController < ApplicationController
  before_action :set_chat_room, only: [:show]

  def index
    @chat_rooms = ChatRoom.all
  end

  def show
    @messages = @chat_room.messages.recent.includes(:user)
    @message = Message.new
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)
    
    if @chat_room.save
      redirect_to @chat_room, notice: 'Chat room was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name, :description)
  end
end
