require 'spec_helper'

describe Metrc::Errors do
  let(:subject) { described_class }

  describe '.parse_request_errors' do
    let(:body) { Hash.new }
    let(:response) do
      double(HTTParty::Response, parsed_response: body)
    end
    let(:parse_request_errors) { subject.parse_request_errors(response: response) }

    context 'with a simple error' do
      let(:body) do
        { 'Message' => 'No data was submitted.' }
      end

      it 'stores the error message' do
        expect(parse_request_errors).to match /No data was submitted./
      end
    end

    context 'with multiple errors for the same row' do
      let(:body) do
        [
          { 'row' => 0, 'message' => 'Room Id was not specified.' },
          { 'row' => 0, 'message' => 'Room "My Room" already exists in the current Facility.' }
        ]
      end

      it 'consolidates the error message from the api' do
        expect(parse_request_errors).to match /Room Id was not specified/
        expect(parse_request_errors).to match /Room "My Room" already exists in the current Facility/
      end
    end

    context 'with errors for multilpe rows' do
      let(:body) do
        [
          { 'row' => 0, 'message' => 'Room Id was not specified.' },
          { 'row' => 1, 'message' => 'Room "My Room" already exists in the current Facility.' }
        ]
      end

      it 'captures the error message for each row' do
        expect(parse_request_errors).to match /0: Room Id was not specified/
        expect(parse_request_errors).to match /1: Room "My Room" already exists in the current Facility/
      end
    end
  end
end
