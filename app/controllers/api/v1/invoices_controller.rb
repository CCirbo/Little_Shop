class Api::V1::InvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    status = params[:status]

    if ['shipped', 'packaged', 'returned'].include?(status)
      invoices = merchant.invoices.where(status: status)
    else
      return render json: { error: 'Invalid status' }, status: :bad_request
    end

    render json: InvoiceSerializer.new(invoices)
  end
end


