class HomeController < ApplicationController
  def index
    redirect_to main_path if user_signed_in?
  end
end
