class MerchantSerializer
  include JSONAPI::Serializer

  attributes :name, :created_at

  # merchants passed in as arg in Serializer
  attribute :item_count do |merchant|
    merchant.items.count
  end
end
