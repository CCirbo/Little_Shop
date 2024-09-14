class MerchantSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :item_count, if: Proc.new {|merchants, params| params && params[:action] == "index" }
  # require "pry"; binding.pry

end
