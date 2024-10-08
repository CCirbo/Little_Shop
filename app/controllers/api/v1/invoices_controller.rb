class Api::V1::InvoicesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    merchant = Merchant.find(params[:merchant_id])
    status = params[:status]

    if ['shipped', 'packaged', 'returned'].include?(status)
      invoices = merchant.invoices.where(status: status)
      render json: InvoiceSerializer.new(invoices)
    elsif status.nil?
      invoices = merchant.invoices
      render json: InvoiceSerializer.new(invoices)
    else
      return render json: { error: 'Invalid status' }, status: :bad_request
    end
  end

  def not_found_response(e)
    render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: :not_found
  end
end


