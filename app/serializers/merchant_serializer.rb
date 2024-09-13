class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  # Can reference a model method with a custom attribute
end
