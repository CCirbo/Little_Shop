class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

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

  def destroy
    item = Item.find(params[:id])
    item.destroy
    head :no_content
  # rescue ActiveRecord::RecordNotFound
  #   head :not_found 
  end
  
  def find_one
    item = Item.find_one_by_name(params[:name])
    if item
      render json: ItemSerializer.new(item)
    else
      not_found_response("No matching item found")
    end
  end

  def find_all
    items = Item.sort_and_filter(filter_params)
    render json: ItemSerializer.new(items)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def filter_params
    params.permit(:name, :min_price, :max_price)
  end

  def not_found_response(e)
    render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: :not_found
  end

end