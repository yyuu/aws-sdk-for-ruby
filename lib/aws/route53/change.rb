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
    class Change < Core::Resource

      # @private
      def initialize id, options = {}
        @id = id
        super
      end

      # @return [String]
      attr_reader :id

      attribute :status, :static => true

      attribute :submitted_at, :static => true

      populates_from :delete_hosted_zone do |resp|
        resp if resp[:id] == id
      end

      populates_from :get_change do |resp|
        resp if resp[:id] == id
      end

      # @return [Boolean] Returns true if this alarm exists.
      def exists?
        get_resource.data[:id] == id
      end

      protected

      def resource_identifiers
        [[:id, id]]
      end

      def get_resource attr_name = nil
        client.get_change(:id => id)
      end

    end
  end
end
