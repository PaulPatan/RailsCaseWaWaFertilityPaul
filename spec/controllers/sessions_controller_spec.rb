require 'rails_helper'

RSpec.describe "User Sessions", type: :request do
  let(:user) { create(:user, email: "test@example.com", password: "password123") }

  describe "GET /users/sign_in" do
    it "displays the login form" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Log in")
    end
  end

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      let(:valid_credentials) do
        {
          user: {
            email: user.email,
            password: "password123"
          }
        }
      end

      it "signs in the user" do
        post user_session_path, params: valid_credentials
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("Signed in successfully")
      end

      it "redirects to the root path after successful login" do
        post user_session_path, params: valid_credentials
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid credentials" do
      let(:invalid_credentials) do
        {
          user: {
            email: user.email,
            password: "wrongpassword"
          }
        }
      end

      it "does not sign in the user" do
        post user_session_path, params: invalid_credentials
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Log in")
      end

      it "displays error message" do
        post user_session_path, params: invalid_credentials
        expect(response.body).to include("Invalid Email or password")
      end
    end

    context "with non-existent email" do
      let(:non_existent_credentials) do
        {
          user: {
            email: "nonexistent@example.com",
            password: "password123"
          }
        }
      end

      it "does not sign in the user" do
        post user_session_path, params: non_existent_credentials
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Log in")
      end
    end
  end

  describe "DELETE /users/sign_out" do
    it "signs out the user" do
      # First sign in the user
      post user_session_path, params: {
        user: { email: user.email, password: "password123" }
      }
      
      # Then sign out
      delete destroy_user_session_path
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it "redirects to the root path after logout" do
      # First sign in the user
      post user_session_path, params: {
        user: { email: user.email, password: "password123" }
      }
      
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "authentication requirements" do
    it "redirects unauthenticated users to login" do
      get chat_rooms_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows authenticated users to access protected pages" do
      post user_session_path, params: {
        user: { email: user.email, password: "password123" }
      }
      get chat_rooms_path
      expect(response).to have_http_status(:success)
    end
  end
end