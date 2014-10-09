class ClientsController < ApplicationController
  def index
  end

  def create
    curr_state = Client.produce_operations(client_params)
    respond_to do |format|
      format.json { render json: curr_state }
    end
  end
  
  def clean
    Client.delete_all
    respond_to do |format|
      format.any(:html, :json, :js) { render noting: true }
    end
  end
  
  private
  def client_params
    params.permit(:format, :step, :operation, :length)
  end
end
