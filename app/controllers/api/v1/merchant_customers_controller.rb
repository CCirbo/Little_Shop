class Api::V1::MerchantCustomersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response


    def index

        customers = Customer.for_merchant(params[:merchant_id])
        render json: CustomerSerializer.new(customers)
    end
    
    #   merchant = Merchant.find(params[:merchant_id])
    #   customers = Customer.joins(:invoices).where(invoices: { merchant_id: merchant.id }).distinct
  
    #   render json: CustomerSerializer.new(customers)
    private 

    def not_found_response(e)
        render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
          .serialize_json, status: :not_found
    end

    
end