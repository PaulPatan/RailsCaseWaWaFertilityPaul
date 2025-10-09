require 'rails_helper'

RSpec.describe "User Registration", type: :request do
  describe "GET /users/sign_up" do
    it "displays the registration form" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sign up")
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          user: {
            full_name: "John Doe",
            email: "john@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end

      it "creates a new user" do
        expect {
          post user_registration_path, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "signs in the user automatically" do
        post user_registration_path, params: valid_attributes
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("Welcome! You have signed up successfully")
      end

      it "redirects to the root path after successful registration" do
        post user_registration_path, params: valid_attributes
        expect(response).to redirect_to(root_path)
      end

      it "creates a user with the correct attributes" do
        post user_registration_path, params: valid_attributes
        user = User.last
        expect(user.full_name).to eq("John Doe")
        expect(user.email).to eq("john@example.com")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          user: {
            full_name: "",
            email: "invalid-email",
            password: "123",
            password_confirmation: "456"
          }
        }
      end

      it "does not create a new user" do
        expect {
          post user_registration_path, params: invalid_attributes
        }.not_to change(User, :count)
      end

      it "renders the registration form again" do
        post user_registration_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Sign up")
      end

      it "displays error messages" do
        post user_registration_path, params: invalid_attributes
        expect(response.body).to include("error")
      end
    end

    context "with missing full_name" do
      let(:missing_full_name_attributes) do
        {
          user: {
            email: "john@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end

      it "does not create a user without full_name" do
        expect {
          post user_registration_path, params: missing_full_name_attributes
        }.not_to change(User, :count)
      end
    end
  end
end