module FakeSessionHelper
  # these are temporary helpers that mirror what Devise will provide when it lands.
  def user_signed_in?
    !params.has_key?("anon")
  end

  def current_user
    @user || User.first
  end
end
