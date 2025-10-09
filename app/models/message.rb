class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  validates :content, presence: true

  scope :recent, -> { order(created_at: :asc) }
end
