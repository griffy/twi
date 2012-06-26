# TODO: Combine present! and present_all! into one
#       super awesome method that can handle a single
#       entity or an array of them
module API
  module Helpers
    module Model
      # Called in place of present when a database
      # model needs to have attributes added to it
      # before it is converted into a representation
      def present!(model, attrs = {})
        # use a default url if none is provided
        attrs.merge! :url => "#{namespace}/#{model.id}" unless attrs.include?(:url)
        # add the additional attributes and their corresponding
        # values to the instance's class
        update_model! model, attrs
        present model
      end

      # Right now, this takes a hash of attributes
      # and their values and applies those to all
      # models. The only special attribute is url,
      # where the url is updated for each model in
      # specific. 
      #
      # FIXME: This should probably accept an array
      # of hashes so we can accept attributes with
      # different values per model. That, or perhaps
      # accept a hash with the following possible keys:
      #   :all/:shared - key that stores a hash of
      #                  attributes and values to be 
      #                  shared across all models
      #
      #   :one/:unique - key that stores an array of
      #                  hashes, where each hash has
      #                  attributes and values for its
      #                  associated model
      #                 
      # FIXME: Currently hacky and assumes JSON output
      def present_all!(models, model_attrs = {})
        body = "["
        models.each do |model|
          attrs = Hash.new
          attrs.merge! model_attrs 
          if attrs.include?(:url)
            attrs[:url] += "/#{model.id}"
          else
            attrs[:url] = "#{namespace}/#{model.id}"
          end
          update_model! model, attrs
          # FIXME: Hack until present can handle arrays of entities
          old_body = body
          present model
          body = old_body + "," + body
        end
        body += "]"
      end

      # Updates a model by dynamically adding
      # attributes to its class
      def update_model!(model, attrs = {})
        # Only update the class for this specific
        # instance
        model.class_eval do
          attrs.each_key do |attr|
            attr_accessor attr
          end
        end

        attrs.each do |attr, attr_val|
          model.send("#{attr.to_s}=".to_sym, attr_val)
        end
      end
    end
  end
end