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
        if params.has_key?(:envelope)
          {
            to: params[:envelope][:to].split(','),
            cc: ccs,
            from: params[:envelope][:from],
            subject: params[:headers][:Subject],
            text: params[:plain],
            attachments: params.fetch(:attachments) { [] },
          }
        else
          params.merge(
            to: recipients(:to),
            cc: recipients(:cc),
            attachments: attachment_files,
          )
        end
      end

      private

      attr_reader :params

      def recipients(key)
        ( params[key] || '' ).split(',')
      end

      def attachment_files
        params.delete('attachment-info')
        attachment_count = params[:attachments].to_i

        attachment_count.times.map do |index|
          params.delete("attachment#{index + 1}".to_sym)
        end
      end

      def ccs
        params[:headers][:Cc].to_s.split(',').map(&:strip)
      end
    end
  end
end
