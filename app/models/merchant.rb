class Merchant < ApplicationRecord

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy

  def self.sort_and_filter(params)
    if params[:status] == "returned"
      merchants_with_returns
    elsif params[:sorted] == "age"
      sort
    else
      Merchant.all
    end
  end

  def self.sort
    Merchant.order(created_at: :desc)
  end

  def self.merchants_with_returns
    Merchant.joins(:invoices).where(invoices: { status: "returned" })
    # We join the Merchant table with the Invoices table
    # That gives us access to ALL the merchants who have invoices actively associated with them
    # Then we .where for those merchants whose invoices have a status of "returned"
  end

  def item_count 
    self.items.count
  end
end

