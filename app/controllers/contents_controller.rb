require 'socket'

class ContentsController < ApplicationController
  def index
    if User.all.length == 0
      u = User.new
      u.email = 'sumikio+10@gmail.com'
      u.save
    end

    @hostname = Socket.gethostname
    @users = User.all
  end
end
