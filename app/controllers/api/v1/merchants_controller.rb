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

    # def show
    #     render json: SongSerializer.format_song(Song.find(params[:id]))
    #  end
end