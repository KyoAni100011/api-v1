class PostParam < BaseParam
  attribute :content, String
  attribute :image_url, optional(String)
end