class BaseParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  class << self
    def attribute(name, type, required: true)
      if type.is_a?(Hash)
        required = type[:required]
        type = type[:type]
      end

      rails_type = map_type(type)

      super(name, rails_type)

      validates name, presence: true if required
    end

    def optional(type)
      { type: type, required: false }
    end

    private

    def map_type(type)
      case type
      when String
        :string
      when Integer
        :integer
      when Float
        :float
      when TrueClass, FalseClass
        :boolean
      else
        :string
      end
    end
  end
end