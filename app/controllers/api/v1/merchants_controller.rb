class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.sort_and_filter(params)
    render json: MerchantSerializer.new(merchants)
    # Need to inject the :item_count key nested under :attributes
    # item_count: should have value of --> merchant.item.count
  end

    # def show
    #     render json: SongSerializer.format_song(Song.find(params[:id]))
    #  end
end

