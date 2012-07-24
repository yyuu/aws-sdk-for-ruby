# Copyright 2011-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module AWS
  class Route53

    # Client class for Route53
    class Client < Core::Client

      API_VERSION = '2012-02-29'

      extend Core::Client::QueryXML

      # @private
      CACHEABLE_REQUESTS = Set[
      ]

      ## client methods ##

      protected

      # CreateHostedZone: POST /2012-02-29/hostedzone
      # GetHostedZone: GET /2012-02-29/hostedzone/${hosted_zone_id}
      # DeleteHostedZone: DELETE /2012-02-29/hostedzone/${hosted_zone_id}
      # ListHostedZones: GET /2012-02-29/hostedzone
      def self.hosted_zone_method(method_name, verb=:get, &block)

        verb = verb.to_s.upcase

        add_client_request_method(method_name) do
          configure_request do |req, options|
            req.http_method = verb
            if options.include?(:id)
              zone_id = options[:id].sub(%r!^/hostedzone/!, '')
              req.path = File.join("/", self.class::API_VERSION, "hostedzone", zone_id)
            else
              req.path = File.join("/", self.class::API_VERSION, "hostedzone")
            end
          end

          instance_eval(&block) if block

          process_response do |response|
            parser = self.class.xml_parsers[method_name]
            response.data = parser.parse(response.http_response.body)
          end

          simulate_response do |response|
            parser = self.class.xml_parsers[method_name]
            response.data = parser.simulate
          end

        end
      end

      # ChangeResourceRecordSets: POST /2012-02-29/hostedzone/${hosted_zone_id}/rrset
      # ListResourceRecordSets: GET /2012-02-29/hostedzone/${hosted_zone_id}/rrset
      def self.rrset_method(method_name, verb=:get, &block)
        verb = verb.to_s.upcase

        add_client_request_method(method_name) do
          configure_request do |req, options|
            req.http_method = verb
            zone_id = options[:id].sub(%r!^/hostedzone/!, '')
            req.path = File.join("/", self.class::API_VERSION, "hostedzone", zone_id, "rrset")
          end

          instance_eval(&block) if block

          process_response do |response|
            parser = self.class.xml_parsers[method_name]
            response.data = parser.parse(response.http_response.body)
          end

          simulate_response do |response|
            parser = self.class.xml_parsers[method_name]
            response.data = parser.simulate
          end

        end
      end

      # GetChanges: GET /2012-02-29/change/${change_id}
      def self.change_method(method_name, verb=:get, &block)
        verb = verb.to_s.upcase

        add_client_request_method(method_name) do
          configure_request do |req, options|
            req.http_method = verb
            req.path = File.join("/", self.class::API_VERSION, "change")
          end

          instance_eval(&block) if block

          process_response do |response|
            parser = self.class.xml_parsers[method_name]
            response.data = parser.parse(response.http_response.body)
          end

          simulate_response do |response|
            parser = self.class.xml_parsers[method_name]
            response.data = parser.simulate
          end

        end
      end

      ## Actions on Hosted Zones
      hosted_zone_method :create_hosted_zone, :post

      hosted_zone_method :get_hosted_zone

      hosted_zone_method :delete_hosted_zone, :delete

      hosted_zone_method :list_hosted_zones

      ## Actions on Resource Record Sets
#     rrset_method :change_resource_record_sets, :post

#     rrset_method :list_method_record_sets

      change_method :get_change

    end
  end
end
