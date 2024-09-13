class Api::V1::ItemsController < ApplicationController
  
  def index
    items = if params[:sorted] == 'price'
              Item.sorted_by_price  
            else
              Item.all  
            end
    render json: ItemSerializer.new(items)
  end
end