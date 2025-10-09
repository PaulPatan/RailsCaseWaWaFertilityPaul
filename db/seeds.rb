# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample chat rooms
ChatRoom.find_or_create_by!(name: "General") do |room|
  room.description = "General discussion for everyone"
end

ChatRoom.find_or_create_by!(name: "Random") do |room|
  room.description = "Random conversations and fun topics"
end

ChatRoom.find_or_create_by!(name: "Tech Talk") do |room|
  room.description = "Discuss technology, programming, and innovation"
end

puts "Created #{ChatRoom.count} chat rooms"
