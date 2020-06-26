module Metrc
  class Configuration
    attr_accessor :api_key,
                  :user_key,
                  :state,
                  :training,
                  :results,
                  :sandbox

    def incomplete?
      %i[api_key state].any? {|e| self.send(e).nil? }
    end
  end
end
