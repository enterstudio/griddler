module Griddler
  module Adapters
    class GustAdapter
      def initialize(params)
        @params = params
      end

      def self.normalize_params(params)
        adapter = new(params)
        adapter.normalize_params
      end

      def normalize_params
        if from_sendgrid?
          SendgridAdapter.normalize_params(params)
        else
          CloudmailinAdapter.normalize_params(params)
        end
      end

      private

      attr_reader :params

      def from_sendgrid?
        params["headers"].is_a?(String) &&
          (params["headers"] =~ /Received: by .*\.sendgrid\.net /).present?
      end
    end
  end
end
