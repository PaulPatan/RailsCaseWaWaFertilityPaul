require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without a full_name' do
      user = build(:user, :without_full_name)
      expect(user).not_to be_valid
      expect(user.errors[:full_name]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with an invalid email format' do
      user = build(:user, :invalid_email)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it 'is not valid without a password' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is not valid with a password that is too short' do
      user = build(:user, :short_password)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it 'is not valid with duplicate email' do
      create(:user, email: "duplicate@example.com")
      user = build(:user, email: "duplicate@example.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it 'has many messages' do
      association = User.reflect_on_association(:messages)
      expect(association.macro).to eq(:has_many)
    end

    it 'destroys associated messages when user is destroyed' do
      user = create(:user)
      chat_room = create(:chat_room)
      message = create(:message, user: user, chat_room: chat_room)
      
      expect { user.destroy }.to change { Message.count }.by(-1)
    end
  end

  describe 'devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe 'instance methods' do
    let(:user) { create(:user, full_name: "Jane Smith") }

    it 'returns the full name' do
      expect(user.full_name).to eq("Jane Smith")
    end

    it 'can authenticate with correct password' do
      expect(user.valid_password?("password123")).to be true
    end

    it 'cannot authenticate with incorrect password' do
      expect(user.valid_password?("wrongpassword")).to be false
    end
  end
end