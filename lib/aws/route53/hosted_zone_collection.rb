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

require 'time'

module AWS
  class Route53

    # TODO:
    #
    class HostedZoneCollection

      include Core::Collection::WithLimitAndNextToken

      def initialize options = {}
        @filters = options[:filters] || {}
        super
      end

      # @param [String] zone_id
      # @return [HostedZone]
      def [] zone_id
        HostedZone.new(zone_id, :config => config)
      end

      # TODO:
      def create name, options = {}
        options[:name] = name
        options[:caller_reference] = "CreateHostedZone, #{name}, #{Time.now.httpdate}" unless options[:caller_reference]
        resp = client.create_hosted_zone(options)
        self[resp[:id]]
      end

      protected

      def _each_item next_token, limit, options = {}, &block

        options = @filters.merge(options)

        options[:marker] = next_token if next_token
        options[:maxitems] = limit if limit

        resp = client.list_hosted_zones(options)
        resp.data[:hosted_zones].each do |details|
          hosted_zone = HostedZone.new_from(
            :list_hosted_zones,
            details, 
            details[:id],
            :config => config)

          yield(hosted_zone)

        end

        resp.data[:next_marker]

      end

    end
  end
end
