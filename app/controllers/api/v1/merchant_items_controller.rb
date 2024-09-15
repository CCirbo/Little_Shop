class Api::V1::MerchantItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def show
    item = Item.find(params[:id])
    if item
      merchant = item.merchant
      render json: MerchantSerializer.new(merchant)
    else
      head :not_found
    end
  end

  private 

  def not_found_response(e)
    render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: :not_found
  end
end
