require "rails_helper"

RSpec.describe "Registrations", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  # the UI sends all the attributes, even the ones that aren't changing
  # build a list of parameters like that and allow specific overrides
  def user_attrs(new_attrs)
    old_attrs = {"first_name" => user.first_name, "last_name" => user.last_name,
                 "email" => user.email, "username" => user.username}
    {"user" => old_attrs.merge(new_attrs)}
  end

  describe "changing user attributes other than password" do
    it "should allow user editing names" do
      put user_registration_url, params: user_attrs(first_name: "NewFirst", last_name: "NewLast")

      expect(response).to redirect_to(user_root_url)
      # arguably we shouldn't (re)test Device/ActiveRecord
      user.reload
      expect(user.first_name).to eq("NewFirst")
      expect(user.last_name).to eq("NewLast")
    end

    it "should allow user editing username" do
      put user_registration_url, params: user_attrs(username: "NewUser")

      expect(response).to redirect_to(user_root_url)
      user.reload
      expect(user.username).to eq("NewUser")
    end

    it "should allow user editing email" do
      put user_registration_url, params: user_attrs(email: "new@test.com")

      expect(response).to redirect_to(user_root_url)
      user.reload
      expect(user.email).to eq("new@test.com")
    end
  end

  describe "password editing" do
    it "should modify the password if all three passwords are correct" do
      current_password = "Testy McTester"  # from factories.rb
      orig_encrypted = user.encrypted_password

      put user_registration_url, params: user_attrs(current_password: current_password,
        password: "New Password", password_confirmation: "New Password")

      expect(response).to redirect_to(user_root_url)
      user.reload
      expect(user.encrypted_password).to_not eq(orig_encrypted)
      # could try to login again, but let's trust Devise
    end

    it "should require the current password to be correct" do
      orig_encrypted = user.encrypted_password

      put user_registration_url, params: user_attrs(current_password: "wrong password",
        password: "New Password", password_confirmation: "New Password")

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:edit)
      user.reload
      expect(user.encrypted_password).to eq(orig_encrypted)
    end

    it "should require that both new passwords match" do
      current_password = "Testy McTester"  # from factories.rb
      orig_encrypted = user.encrypted_password

      put user_registration_url, params: user_attrs(current_password: current_password,
        password: "New Password", password_confirmation: "wrong password")

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:edit)
      user.reload
      expect(user.encrypted_password).to eq(orig_encrypted)
    end
  end
end
