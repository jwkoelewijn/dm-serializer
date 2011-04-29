require 'dm-core'

module DataMapper
  module Serializer

    # Returns propreties to serialize based on :only or :exclude arrays,
    # if provided :only takes precendence over :exclude
    #
    # @return [Array]
    #   Properties that need to be serialized.
    def properties_to_serialize(options)
      only_properties     = Array(options[:only])
      excluded_properties = Array(options[:exclude])

      model.properties(repository.name).reject do |p|
        if only_properties.include? p.name
          false
        else
          excluded_properties.include?(p.name) ||
          !(only_properties.empty? ||
          only_properties.include?(p.name))
        end
      end
    end

    # add properties as a result from the serialization callback
    def invoke_serialization_callback
      serialization_callback_result = {}
      if respond_to?(:serialization_callback)
        serialization_callback_result = serialization_callback
        unless serialization_callback_result.is_a?(Hash)
          raise "#serialization_callback should return a Hash, found #{serialization_callback_result.class}"
        end
      end
      serialization_callback_result
    end

  end

  Model.append_inclusions(Serializer)
end
