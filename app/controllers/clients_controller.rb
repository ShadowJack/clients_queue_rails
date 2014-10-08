class ClientsController < ApplicationController
  def index
    @client = Client.new
  end

  def create
    Client.create(client_params)
    redirect_to root_path
  end
  
  private
  
  def client_params
    params.require(:client).permit(:operation, :length)
  end
end
