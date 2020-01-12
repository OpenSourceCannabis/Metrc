module Metrc
  include Constants
  include Errors

  class Client
    include HTTParty
    headers 'Content-Type' => 'application/json'

    attr_accessor :debug,
                  :response,
                  :parsed_response

    def self.init(credentials)

      Metrc.configure do |config|
        config.api_key = credentials['api_key'] if credentials['api_key']
        config.user_key = credentials['user_key'] if credentials['user_key']
        config.license_number = credentials['license_number'] if credentials['license_number']
        config.base_uri = credentials['base_uri'] if credentials['base_uri']
        config.state = credentials['state'] if credentials['state']
      end

      new
    end

    def initialize(opts = {})
      self.debug = opts[:debug]
      self.class.base_uri configuration.base_uri
      sign_in
    end

    ## CIM Common Interface Methods
    ## Metrc / BioTrackTHC / LeafData

    def retrieve(barcode)
      get_package(barcode)
      response.parsed_response.is_a?(Hash) ? response.parsed_response : nil
    end

    def inbox
      list_manifests
    end

    def api_get(url, options = {})
      options[:basic_auth] = auth_headers
      puts "\nMetrc API Request debug\nclient.get('#{url}', #{options})\n########################\n" if debug
      self.response = self.class.get(url, options)
      if debug
        puts "\nMetrc API Response debug\n#{response.to_s[0..360]}\n[200 OK]\n########################\n"
        response
      end
    end

    def api_post(url, options = {})
      options[:basic_auth] = auth_headers
      puts "\nMetrc API Request debug\nclient.post('#{url}', #{options})\n########################\n" if debug
      self.response = self.class.post(url, options)
      if debug
        puts "\nMetrc API Response debug\n#{response.to_s[0..360]}\n[200 OK]\n########################\n"
        response
      end
    end

    def api_delete(url, options = {})
      options[:basic_auth] = auth_headers
      puts "\nMetrc API Request debug\nclient.delete('#{url}', #{options})\n########################\n" if debug
      self.response = self.class.delete(url, options)
      if debug
        puts "\nMetrc API Response debug\n#{response.to_s[0..360]}\n[200 OK]\n########################\n"
        response
      end
    end

    # GET
    def get_room(id)
      get(:rooms, id)
    end

    def get_package(id)
      get(:packages, id)
    end

    def get_strain(id)
      get(:strains, id)
    end

    def get(resource, resource_id)
      api_get("/#{resource}/v1/#{resource_id}")
    end

    # LIST
    def list_rooms
      list(:rooms)
    end

    def list_strains
      list(:strains)
    end

    def list_packages
      list(:packages)
    end

    def list_manifests(start_date = nil, end_date = nil)
      start_date ||= days_ago(1)
      end_date ||= today
      api_get("/transfers/v1/incoming?licenseNumber=#{configuration.license_number}&lastModifiedStart=#{start_date}&lastModifiedEnd=#{end_date}").sort_by{|el| el['Id']}
    end

    def list(resource)
      api_get("/#{resource}/v1/active?licenseNumber=#{configuration.license_number}").sort_by{ |el| el['Id'] }
    end

    # CREATE
    def create_rooms(resources)
      create(:rooms, resources)
    end

    def create_strains(resources)
      create(:strains, resources)
    end

    def create(resource, resources)
      api_post("/#{resource}/v1/create?licenseNumber=#{configuration.license_number}", body: resources.to_json)
    end

    # UPDATE
    def update_rooms(resources)
      update(:rooms, resources)
    end

    def update_strains(resources)
      update(:strains, resources)
    end

    def update(resource, resources)
      api_post("/#{resource}/v1/update?licenseNumber=#{configuration.license_number}", body: resources.to_json)
    end

    # DELETE
    def delete_room(id)
      delete(:rooms, id)
    end

    def delete_strain(id)
      delete(:strains, id)
    end

    def delete(resource, resource_id)
      api_delete("/#{resource}/v1/#{resource_id}?licenseNumber=#{configuration.license_number}")
    end

    # LABORATORY RESULTS
    def labtest_states
      @labtest_states ||= api_get('/labtests/v1/states')
    end

    def labtest_types
      @labtest_types ||= api_get('/labtests/v1/types').sort_by { |el| el['Id'] }
    end

    def create_results(label, results = [], results_date = Time.now.utc.iso8601)
      get_package(label)
      raise Errors::NotFound.new("Package `#{label}` not found") if response.parsed_response.nil?
      
      api_post(
        "/labtests/v1/record?licenseNumber=#{configuration.license_number}",
        body: [{
          'Label' => label,
          'ResultDate' => results_date,
          'Results' => sanitize(results)
        }].to_json
      )
    end

    def sanitize(results)
      results
      # allowed_test_types = labtest_types.map { |el| el['Name'] }
      # results.select { |result| allowed_test_types.include?(result[:LabTestTypeName]) }
    end

    def signed_in?
      true
    end

    private

    def today
      Time.now.strftime('%F')
    end

    def days_ago(count)
      (Time.now - 86_400 * count).strftime('%F')
    end

    def auth_headers
      {
        username: configuration.api_key.strip, 
        password: configuration.user_key.strip
      }
    end

    def sign_in
      raise Errors::MissingConfiguration if configuration.incomplete?

      true
    end

    def configuration
      Metrc.configuration
    end
  end
end
