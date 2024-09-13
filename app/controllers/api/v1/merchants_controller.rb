class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = if params[:sorted] == 'age'
        Merchant.sorted_by_age
      else
        Merchant.all
      end
    render json: MerchantSerializer.new(merchants)
  end


  def show
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
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
      merchant = Merchant.find(params[:id])
      merchant.destroy  # Use destroy to trigger dependent: :destroy
      head :no_content  # This should return a 204 No Content status
    rescue ActiveRecord::RecordNotFound
      head :not_found  # If the merchant is not found, return 404 Not Found
    end

  private

  def merchant_params
      params.require(:merchant).permit(:name)
  end
end