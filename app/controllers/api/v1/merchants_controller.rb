class Api::V1::MerchantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def index
      merchants = Merchant.sort_and_filter(params)
      render json: MerchantSerializer.new(merchants, {params: {action: "index"} } )
  end

  def show
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def update
      merchant = Merchant.find(params[:id])
      merchant.update(merchant_params)
      render json: MerchantSerializer.new(merchant)
  end

  def create
      new_merchant = Merchant.create(merchant_params)
      render json: MerchantSerializer.new(new_merchant), status: 201
  end

  def destroy
    # begin
      merchant = Merchant.find(params[:id])
      merchant.destroy  
      head :no_content  
    # rescue ActiveRecord::RecordNotFound
#       head :not_found 
    # end
  end

  private

  def merchant_params
      params.require(:merchant).permit(:name)
  end

  def not_found_response(e)
    render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: :not_found
  end
end
