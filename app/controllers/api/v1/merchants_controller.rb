class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.sort_and_filter(params)
    render json: MerchantSerializer.new(merchants, meta: { count: merchants.count })
  end

    # def show
    #     render json: SongSerializer.format_song(Song.find(params[:id]))
    #  end
end

