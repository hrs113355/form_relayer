require "form_relayer/version"

module FormRelayer
  module ViewHelper
    def relay_received_post_params(options = {})
      tags = []

      raw_params= Rack::Utils.parse_query(request.raw_post)
      raw_params.delete('utf8')
      raw_params.delete('authenticity_token')
      options[:excepts].each { |except_tag| raw_params.delete(except_tag) } if options[:excepts].present?

      raw_params.each do |name, value|
        if value.is_a?(Array)
          value.each { |v| tags << hidden_field_tag(name, v) }
        else
          tags << hidden_field_tag(name, value)
        end
      end

      safe_join(tags)
    end
  end
end

require "action_view"
class ActionView::Base
  include FormRelayer::ViewHelper
end
