class CreateChatRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
