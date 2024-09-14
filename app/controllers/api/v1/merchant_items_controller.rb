class Api::V1::MerchantItemsController < ApplicationController
  def show
    item = Item.find_by(id: params[:id])
    if item
      merchant = item.merchant
      render json: MerchantSerializer.new(merchant)
    else
      head :not_found
    end
  end
end
