# rubocop:disable Naming/FileName,Lint/MissingCopEnableDirective

require 'httparty'
require 'Metrc/constants'
require 'Metrc/errors'
require 'Metrc/configuration'
require 'Metrc/client'
require 'Metrc/version'

module Metrc
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&_block)
    yield configuration
  end
end
