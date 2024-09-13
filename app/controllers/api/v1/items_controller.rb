class Api::V1::ItemsController < ApplicationController
  
  def index 
    items = Item.all
    render json: ItemSerializer.new(items)
  end

  def create
    new_item = Item.create(item_params)
    render json: ItemSerializer.new(new_item), status: 201
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end