require 'socket'

class ContentsController < ApplicationController
  def index
    @hostname = Socket.gethostname
    @users = User.all
  end
end
