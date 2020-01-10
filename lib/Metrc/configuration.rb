module Metrc
  class Configuration
    attr_accessor :api_key,
                  :user_key,
                  :license_number,
                  :base_uri,
                  :state,
                  :training,
                  :results

    def incomplete?
      %i[api_key user_key license_number base_uri state].any? { |e| self.send(e).nil? }
    end
  end
end
