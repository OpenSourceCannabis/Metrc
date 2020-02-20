require 'spec_helper'

describe Metrc::Client do
  before(:each) do
    configure_client
  end

  let(:subject) { described_class.new(user_key: $spec_credentials['user_key']) }
  let(:licenseNumber) { 'CML17-0000001' }

  describe '#api_post' do
    let(:api_url) { "/foo/v1/bar?licenseNumber=#{licenseNumber}" }
    let(:api_post) { subject.api_post(api_url) }
    let(:body) { "" }

    before(:each) do
      stub_request(:post, "#{subject.uri}#{api_url}")
        .to_return(status: status, body: body, headers: { 'content-type': 'application/json' })
    end

    context 'Metrc API returns 400' do
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

    context 'Metrc API returns 401' do
      let(:status) { 401 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::Unauthorized))
      end
    end

    context 'Metrc API returns 403' do
      let(:status) { 403 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::Forbidden))
      end
    end

    context 'Metrc API returns 404' do
      let(:status) { 404 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::NotFound))
      end
    end

    context 'Metrc API returns 429' do
      let(:status) { 429 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::TooManyRequests))
      end
    end

    context 'Metrc API returns 500' do
      let(:status) { 500 }
      it 'raises an error' do
        expect { api_post }.to(raise_error(Metrc::Errors::InternalServerError))
      end

      # TODO: enhance error capturing for 500s once response format is known
      #context 'with a simple error' do
      #  let(:body) do
      #    { 'Message': 'No data was submitted.' }.to_json
      #  end

      #  it 'stores the error message' do
      #    expect { api_post }.to(raise_error('No data was submitted.'))
      #  end
      #end
    end
  end

  describe '#change_plant_growth_phase' do
    before(:each) do
      content_type = { 'content-type': 'application/json' }
      stub_request(:post, "#{subject.uri}/plants/v1/changegrowthphases?licenseNumber=#{licenseNumber}")
        .with(headers: content_type)
        .to_return(body: nil)
    end

    it 'calls the endpoint' do
      expect { subject.change_plant_growth_phase(licenseNumber, []) }.not_to raise_error
    end
  end

  context 'packages' do
    describe '#create_package' do
      context 'not for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/create?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.create_package(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/create/testing?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
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
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/change/item?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.change_package_item(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/change/item/testing?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.change_package_item(licenseNumber, [], true) }.not_to raise_error
        end
      end
    end

    describe '#adjust_package' do
      context 'not for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/adjust?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.adjust_package(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/adjust/testing?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.adjust_package(licenseNumber, [], true) }.not_to raise_error
        end
      end
    end

    describe '#finish_package' do
      context 'not for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/finish?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.finish_package(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/finish/testing?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.finish_package(licenseNumber, [], true) }.not_to raise_error
        end
      end
    end

    describe '#unfinish_package' do
      context 'not for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/unfinish?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.unfinish_package(licenseNumber, []) }.not_to raise_error
        end
      end

      context 'for testing' do
        before(:each) do
          content_type = { 'content-type': 'application/json' }
          stub_request(:post, "#{subject.uri}/packages/v1/unfinish/testing?licenseNumber=#{licenseNumber}")
            .with(headers: content_type)
            .to_return(body: nil)
        end

        it 'calls the endpoint' do
          expect { subject.unfinish_package(licenseNumber, [], true) }.not_to raise_error
        end
      end
    end
  end

  context 'harvest' do
    describe '#finish_harvest' do
      before(:each) do
        content_type = { 'content-type': 'application/json' }
        stub_request(:post, "#{subject.uri}/harvests/v1/finish?licenseNumber=#{licenseNumber}")
          .with(headers: content_type)
          .to_return(body: nil)
      end

      it 'calls the endpoint' do
        expect { subject.finish_harvest(licenseNumber, []) }.not_to raise_error
      end
    end
  end
end
