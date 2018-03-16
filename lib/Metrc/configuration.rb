module Metrc
  class Configuration
    attr_accessor :api_key,
                  :user_key,
                  :base_uri,
                  :state,
                  :training,
                  :results

    def incomplete?
      [:api_key, :user_key, :base_uri, :state].any? { |e| self.send(e).nil? }
    end

  end
end
