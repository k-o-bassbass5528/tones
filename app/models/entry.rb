class Entry < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :room

  after_destroy :destroy_room_immediately

  private

  def destroy_room_immediately
    room.destroy
  end
end
