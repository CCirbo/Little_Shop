class Api::V1::ItemsController < ApplicationController
  
  def index
    items = if params[:sorted] == 'price'
              Item.sorted_by_price  
            else
              Item.all  
            end
    render json: ItemSerializer.new(items)
  end


  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def update
    updated_item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(updated_item)
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