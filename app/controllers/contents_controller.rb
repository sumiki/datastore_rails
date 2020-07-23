class ContentsController < ApplicationController
  def index

    if User.all.length == 0
      user = User.new
      user.email = 'sumikio@gmail.com'
      user.save
    end
    @users = User.all
  end
end
