class Api::V1::MerchantsController < ApplicationController
    def index
        # if params[:count]
        #     merchants = Merchant.calculated_count
        # elsif params[:sorted]
        #     merchants = Merchant.sort_by_age
        # elsif params[:status]
        #     merchants = Merchant.returned_items(params[:status])
        # else 
            merchants = Merchant.all
        # end
      render json: MerchantSerializer.new(merchants)
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

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end

end