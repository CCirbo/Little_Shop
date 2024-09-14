class Api::V1::MerchantCustomersController < ApplicationController
    def index

        customers = Customer.for_merchant(params[:merchant_id])
        render json: CustomerSerializer.new(customers)
    
    #   merchant = Merchant.find(params[:merchant_id])
    #   customers = Customer.joins(:invoices).where(invoices: { merchant_id: merchant.id }).distinct
  
    #   render json: CustomerSerializer.new(customers)
    end
  end