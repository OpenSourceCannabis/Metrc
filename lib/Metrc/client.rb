module Metrc
  include Constants
  include Errors

  class Client
    include HTTParty
    headers 'Content-Type' => 'application/json'

    attr_accessor :debug,
                  :response,
                  :parsed_response

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

    def api_get(url, options = {})
      options.merge!(basic_auth: auth_headers)
      puts "\nMetrc API Request debug\nclient.get('#{url}', #{options})\n########################\n" if debug
      self.response = self.class.get(url, options)
      if debug
        puts "\nMetrc API Response debug\n#{response.to_s[0..360]}\n[200 OK]\n########################\n"
        response
      end
    end

    def api_post(url, options = {})
      options.merge!(basic_auth: auth_headers)
      puts "\nMetrc API Request debug\nclient.post('#{url}', #{options})\n########################\n" if debug
      self.response = self.class.post(url, options)
      if debug
        puts "\nMetrc API Response debug\n#{response.to_s[0..360]}\n[200 OK]\n########################\n"
        response
      end
    end

    def api_delete(url, options = {})
      options.merge!(basic_auth: auth_headers)
      puts "\nMetrc API Request debug\nclient.delete('#{url}', #{options})\n########################\n" if debug
      self.response = self.class.delete(url, options)
      if debug
        puts "\nMetrc API Response debug\n#{response.to_s[0..360]}\n[200 OK]\n########################\n"
        response
      end
    end

    def api_put(url, options = {})
      options.merge!(basic_auth: auth_headers)
      puts "\nMetrc API Request debug\nclient.put('#{url}', #{options})\n########################\n" if debug
      self.response = self.class.put(url, options)
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
    def list_rooms(license_number)
      list(:rooms, license_number)
    end

    def list_strains(license_number)
      list(:strains, license_number)
    end

    def list(resource, license_number)
      api_get("/#{resource}/v1/active?licenseNumber=#{license_number}").sort_by{|el| el['Id']}
    end

    # CREATE
    def create_rooms(license_number, resources)
      create(:rooms, license_number, resources)
    end

    def create_strains(license_number, resources)
      create(:strains, license_number, resources)
    end

    def create_plant_batches(license_number, resources)
      api_post("/plantbatches/v1/createplantings?licenseNumber=#{license_number}", body: resources.to_json)
    end

    def move_plant_batches(license_number, resources)
      api_put("/plantbatches/v1/moveplantbatches?licenseNumber=#{license_number}", body: resources.to_json)
    end

    def change_growth_phase(license_number, resources)
      api_post("/plantbatches/v1/changegrowthphase?licenseNumber=#{license_number}", body: resources.to_json)
    end

    def create(resource, license_number, resources)
      api_post("/#{resource}/v1/create?licenseNumber=#{license_number}", body: resources.to_json)
    end

    # UPDATE
    def update_rooms(license_number, resources)
      update(:rooms, license_number, resources)
    end

    def update_strains(license_number, resources)
      update(:strains, license_number, resources)
    end

    def update(resource, license_number, resources)
      api_post("/#{resource}/v1/update?licenseNumber=#{license_number}", body: resources.to_json)
    end

    # DELETE
    def delete_room(license_number, id)
      delete(:rooms, license_number, id)
    end

    def delete_strain(license_number, id)
      delete(:strains, license_number, id)
    end

    def delete(resource, license_number, resource_id)
      api_delete("/#{resource}/v1/#{resource_id}?licenseNumber=#{license_number}")
    end

    # LABORATORY RESULTS
    def labtest_states
      @labtest_states ||= api_get('/labtests/v1/states')
    end

    def labtest_types
      @labtest_types ||= api_get('/labtests/v1/types').sort_by{|el| el['Id']}
    end

    def create_results(label, license_number, results = [], results_date = Time.now.utc.iso8601)
      get_package(label)
      raise Errors::NotFound.new("Package `#{label}` not found") if response.parsed_response.nil?
      api_post(
        "/labtests/v1/record?licenseNumber=#{license_number}",
        body: [{
          'Label'      => label,
          'ResultDate' => results_date,
          'Results'    => sanitize(results)
        }].to_json
      )
    end

    def sanitize(results)
      allowed_test_types = labtest_types.map{|el| el['Name']}
      results.reject{|result| !allowed_test_types.include?(result[:LabTestTypeName])}
    end

    def signed_in?
      true
    end

    private

    def auth_headers
      { username: configuration.api_key, password: configuration.user_key }
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
