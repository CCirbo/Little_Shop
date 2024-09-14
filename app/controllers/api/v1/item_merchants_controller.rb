class Api::V1::ItemMerchantsController < ApplicationController

  def index
    merchant = Merchant.find(params[:id])
    items = merchant.items
    render json: ItemSerializer.new(items)
  end

end