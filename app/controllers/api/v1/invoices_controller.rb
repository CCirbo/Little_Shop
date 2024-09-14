class Api::V1::InvoicesController <> ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    status = params[:status]

    



  end
end