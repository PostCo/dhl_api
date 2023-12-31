module DHLAPI
  class RetoureClient < BaseClient
    URL = 'https://api-eu.dhl.com/parcel/de/shipping/returns/v1/orders'
    TEST_URL = 'https://api-sandbox.dhl.com/parcel/de/shipping/returns/v1/orders'

    def initialize(username: nil, password: nil, label_type: 'BOTH')
      @username = username
      @password = password
      @label_type = label_type
    end

    # @overload label_type
    #   Read the label type. Default to 'BOTH'
    #   @return [string] The label type you will to receive
    # @overload label_type=(value)
    #   @param value [String] possible values: 'BOTH', 'SHIPMENT_LABEL', 'QR_LABEL'
    attr_accessor :label_type

    def create_label(attributes = {})
      payload = attributes.deep_transform_keys { |key| key.to_s.camelize(:lower) }
      self.response = connection.post(url, json: payload, params: { labelType: label_type })
      RetoureLabel.new handle_response.parse
    end

    def connection
      super.basic_auth(user: username, pass: password)
    end

    private

    def username
      @username ||= ENV['DHLAPI_RETOURE_USERNAME']
    end

    def password
      @password ||= ENV['DHLAPI_RETOURE_PASSWORD']
    end
  end
end
