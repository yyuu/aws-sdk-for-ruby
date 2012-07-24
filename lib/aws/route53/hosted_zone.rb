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

    # TODO:
    class HostedZone < Core::Resource

      # @private
      def initialize id, options = {}
        @id = id.sub(%r!^/hostedzone/!, '')
        super
      end

      # @return [String]
      attr_reader :id

      def path
        "/hostedzone/#{id}"
      end

      attribute :name, :static => true

      attribute :caller_reference, :static => true

      attribute :config, :static => true

      attribute :resource_record_set_count, :static => true

      attribute :delegation_set, :static => true

      populates_from :get_hosted_zone do |resp|
        resp if resp[:id] == path
      end

      populates_from :list_hosted_zones do |resp|
        resp.data[:hosted_zones].find { |detail| detail[:id] == path }
      end

      # Deletes the hosted zone.
      # @return [Change]
      def delete
        resp = client.delete_hosted_zone(:id => id)
        Change.new_from(:delete_hosted_zone, resp, resp[:id], :config => config) if resp and resp[:id]
      end

      # @return [Boolean] Returns true if this alarm exists.
      def exists?
        get_resource.data[:id] == path
      end

      def inspect
        "<#{self.class} id:#{self.id} name:#{self.name} caller_reference:#{self.caller_reference}>"
      end

      protected

      def resource_identifiers
        [[:id, id]]
      end

      def get_resource attr_name = nil
        client.get_hosted_zone(:id => id)
      end

    end
  end
end
