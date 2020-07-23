require 'spec_helper'

describe Metrc::Client do
  before(:each) do
    configure_client
  end

  let(:subject) { described_class.new(user_key: $spec_credentials['user_key']) } # rubocop:disable Style/GlobalVars
  let(:licenseNumber) { 'CML17-0000001' }
  let(:headers) do
    { 'content-type': 'application/json' }
  end

  describe '#api_post' do
    let(:api_url) { "/foo/v1/bar?licenseNumber=#{licenseNumber}" }
    let(:api_post) { subject.api_post(api_url) }
    let(:body) { '' }

    before(:each) do
      stub_request(:post, "#{subject.uri}#{api_url}")
        .to_return(status: status, body: body, headers: headers)
    end

    context 'with a 400 response' do
      let(:status) { 400 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::BadRequest))
      end

      context 'with a simple error' do
        let(:body) do
          { 'Message': 'No data was submitted.' }.to_json
        end

        it 'stores the error message' do
          expect { api_post }.to(raise_error(/No data was submitted./))
        end
      end
    end

    context 'with a 401 response' do
      let(:status) { 401 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::Unauthorized))
      end
    end

    context 'with a 403 response' do
      let(:status) { 403 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::Forbidden))
      end
    end

    context 'with a 404 response' do
      let(:status) { 404 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::NotFound))
      end
    end

    context 'with a 429 response' do
      let(:status) { 429 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::TooManyRequests))
      end
    end

    context 'with a 500 response' do
      let(:status) { 500 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::InternalServerError))
      end
    end
  end

  describe '#change_plant_growth_phase' do
    before(:each) do
      stub_request(:post, "#{subject.uri}/plants/v1/changegrowthphases?licenseNumber=#{licenseNumber}")
        .with(headers: headers)
        .to_return(body: nil)
    end

    it 'calls the endpoint' do
      expect { subject.change_plant_growth_phase(licenseNumber, []) }.not_to raise_error
    end
  end

  context 'batches' do
    describe '#list_plant_batches' do
      before do
        stub_request(:get, "#{subject.uri}/plantbatches/v1/active?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.list_plant_batches(licenseNumber) }.not_to raise_error
      end
    end

    describe '#create_plant_batch_plantings' do
      before do
        stub_request(:post, "#{subject.uri}/plantbatches/v1/create/plantings?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.create_plant_batch_plantings(licenseNumber, []) }.not_to raise_error
      end
    end

    describe '#split_plant_batch' do
      before do
        stub_request(:post, "#{subject.uri}/plantbatches/v1/split?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.split_plant_batch(licenseNumber, []) }.not_to raise_error
      end
    end
  end

  context 'packages' do
    describe '#create_plant_batch_package' do
      after do
        configure_client
      end

      context 'with a migrated state' do
        before do
          stub_request(:post, "#{subject.uri}/plantbatches/v1/create/plantings?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.create_plant_batch_package(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'with a non migrated state' do
        before do
          configure_client(:ma)

          stub_request(:post, "#{subject.uri}/plantbatches/v1/createpackages?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.create_plant_batch_package(licenseNumber, []) }.not_to raise_error
        end
      end
    end

    describe '#create_plant_batch_package_from_mother' do
      before(:each) do
        stub_request(:post, "#{subject.uri}/plantbatches/v1/create/packages/frommotherplant?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.create_plant_batch_package_from_mother(licenseNumber, []) }.not_to raise_error
      end
    end

    describe '#create_plantings_package' do
      before(:each) do
        stub_request(:post, "#{subject.uri}/packages/v1/create/plantings?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.create_plantings_package(licenseNumber, []) }.not_to raise_error
      end
    end

    describe '#create_harvest_package' do
      context 'not for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/harvests/v1/create/packages?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.create_harvest_package(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/harvests/v1/create/packages/testing?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.create_harvest_package(licenseNumber, [], true) }.not_to raise_error
        end
      end
    end

    describe '#create_package' do
      context 'not for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/packages/v1/create?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.create_package(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/packages/v1/create/testing?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.create_package(licenseNumber, [], true) }.not_to raise_error
        end
      end
    end

    describe '#change_package_item' do
      context 'not for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/packages/v1/change/item?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.change_package_item(licenseNumber, []) }.not_to raise_error
        end
      end
    end

    describe '#adjust_package' do
      context 'not for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/packages/v1/adjust?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.adjust_package(licenseNumber, []) }.not_to raise_error
        end
      end
    end

    describe '#finish_package' do
      context 'not for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/packages/v1/finish?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.finish_package(licenseNumber, []) }.not_to raise_error
        end
      end
    end

    describe '#unfinish_package' do
      context 'not for testing' do
        before(:each) do
          stub_request(:post, "#{subject.uri}/packages/v1/unfinish?licenseNumber=#{licenseNumber}")
            .with(headers: headers)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.unfinish_package(licenseNumber, []) }.not_to raise_error
        end
      end
    end
  end

  context 'harvest' do
    describe '#finish_harvest' do
      before(:each) do
        stub_request(:post, "#{subject.uri}/harvests/v1/finish?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.finish_harvest(licenseNumber, []) }.not_to raise_error
      end
    end

    describe '#remove_waste' do
      before(:each) do
        stub_request(:post, "#{subject.uri}/harvests/v1/removewaste?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.remove_waste(licenseNumber, []) }.not_to raise_error
      end
    end

    describe '#get_harvest' do
      let(:harvest_id) { 123 }
      before(:each) do
        stub_request(:get, "#{subject.uri}/harvests/v1/#{harvest_id}?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.get_harvest(licenseNumber, harvest_id) }.not_to raise_error
      end
    end

    describe '#move_harvest' do
      before do
        stub_request(:put, "#{subject.uri}/harvests/v1/move?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.move_harvest(licenseNumber, []) }.not_to raise_error
      end
    end

    describe '#list_harvests' do
      let(:query_params) { '' }

      before do
        stub_request(:get, "#{subject.uri}/harvests/v1/active?licenseNumber=#{licenseNumber}#{query_params}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.list_harvests(licenseNumber) }.not_to raise_error
      end

      context 'with date range' do
        let(:range_start) { '2020-02-20T10:00:00Z' }
        let(:range_end) { '2020-02-25T10:00:00Z' }
        let(:query_params) { "&lastModifiedStart=#{range_start}&lastModifiedEnd=#{range_end}" }

        it 'calls the endpoint' do
          expect { subject.list_harvests(licenseNumber, range_start: range_start, range_end: range_end) }.not_to raise_error
        end
      end
    end
  end

  context 'transfers' do
    describe '#delete_transfer_template' do
      before(:each) do
        stub_request(:delete, "#{subject.uri}/transfers/v1/templates/#{template_id}?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      let(:template_id) { 1 }

      it 'calls the endpoint' do
        expect { subject.delete_transfer_template(licenseNumber, template_id) }.not_to raise_error
      end
    end

    describe '#create_transfer_template' do
      before(:each) do
        stub_request(:post, "#{subject.uri}/transfers/v1/templates?licenseNumber=#{licenseNumber}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.create_transfer_template(licenseNumber, []) }.not_to raise_error
      end
    end

    describe '#list_transfer_templates' do
      let(:query_params) { '' }

      before do
        stub_request(:get, "#{subject.uri}/transfers/v1/templates?licenseNumber=#{licenseNumber}#{query_params}")
          .with(headers: headers)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.list_transfer_templates(licenseNumber) }.not_to raise_error
      end

      context 'with date range' do
        let(:range_start) { '2020-02-20T10:00:00Z' }
        let(:range_end) { '2020-02-25T10:00:00Z' }
        let(:query_params) { "&lastModifiedStart=#{range_start}&lastModifiedEnd=#{range_end}" }

        it 'calls the endpoint' do
          expect { subject.list_transfer_templates(licenseNumber, range_start: range_start, range_end: range_end) }.not_to raise_error
        end
      end
    end
  end
end
