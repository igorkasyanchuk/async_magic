class HomeController < ApplicationController
  before_action :create_visit

  def index
    render plain: "Hello, World!"
  end

  private

  #
  # super basic example
  #

  async
  def create_visit
    sleep 0.1
    Visit.create
  end
end
