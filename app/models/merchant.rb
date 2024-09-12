class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.sort_and_filter(params)
    merchants = Merchant.all
    # merchants = item_returns(merchants, params)
    merchants = sort(merchants, params)
    merchants
  end

  # def self.item_returns(merchants, params)
  #   if params[:]
  # end

  def self.sort(merchants, params)
    if params[:sort] == "asc"
      merchants.order(:created_at)
    else
      merchants
    end
  end
end

