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

    class ResourceRecordSet < Core::Resource

      # @private
      def initialize name, type, set_identifier=nil, options = {}
        @name = name
        @type = type
        @set_identifier = set_identifier
        @hosted_zone_id = options[:hosted_zone_id]
        @change_info = options[:change_info]
        @create_options = {}
        super
      end

      # @return [String]
      attr_reader :hosted_zone_id

      attr_reader :change_info

      attr_reader :name
      def name=(new_name)
        @create_options[:name] = new_name
      end

      attr_reader :type
      def type=(new_type)
        @create_options[:type] = new_type
      end

      attr_reader :set_identifier
      def set_identifier=(new_identifier)
        @create_options[:set_identifier] = new_identifier
      end

      alias_method :identifier, :set_identifier
      alias_method :identifier=, :set_identifier=

      attribute :alias_target, :static => true
      def alias_target=(new_target)
        @create_options[:alias_target] = new_target
      end

      attribute :weight, :static => true
      def weight=(new_weight)
        @create_options[:weight] = new_weight
      end

      attribute :ttl, :static => true
      def ttl=(new_ttl)
        @create_options[:ttl] = new_ttl
      end

      attribute :resource_records, :static => true
      def resource_records=(new_rrs)
        @create_options[:resource_records] = new_rrs
      end

      populates_from :list_resource_record_sets do |resp|
        resp[:resource_record_sets].find { |details|
          details[:name] == name and details[:type] == type and details[:set_identifier] == set_identifier
        }
      end

      # @return [Boolean] Returns true if this rrset exists.
      def exists?
        !get_resource.data[:resource_record_sets].find { |details|
          details[:name] == name and details[:type] == type and details[:set_identifier] == set_identifier
        }.nil?
      end

      def update
        delete_options = {:name => name, :type => type}
        delete_options[:set_identifier] = set_identifier if set_identifier
        delete_options[:alias_target] = alias_target if alias_target
        delete_options[:weight] = weight if weight
        delete_options[:ttl] = ttl if ttl
        delete_options[:resource_records] = resource_records if resource_records

        create_options = delete_options.merge(@create_options)
        @create_options.clear()

        batch = ChangeBatch.new()
        batch << DeleteRequest.new(delete_options)
        batch << CreateRequest.new(create_options)

        resp = client.change_resource_record_sets(batch.build_query(:hosted_zone_id => hosted_zone_id))
        if resp[:change_info][:id]
          change_info = ChangeInfo.new_from(:change_resource_record_sets,
                                            resp[:change_info],
                                            resp[:change_info][:id],
                                            :config => config)
          ResourceRecordSet.new(name,
                                type,
                                set_identifier,
                                :change_info => change_info,
                                :hosted_zone_id => hosted_zone_id,
                                :config => config)
        end
      end

      def delete
        delete_options = {:name => name, :type => type}
        delete_options[:set_identifier] = set_identifier if set_identifier
        delete_options[:alias_target] = alias_target if alias_target
        delete_options[:weight] = weight if weight
        delete_options[:ttl] = ttl if ttl
        delete_options[:resource_records] = resource_records if resource_records

        batch = ChangeBatch.new()
        batch << DeleteRequest.new('DELETE', delete_options)

        resp = client.change_resource_record_sets(batch.build_query(:hosted_zone_id => hosted_zone_id))
        if resp[:change_info][:id]
          ChangeInfo.new_from(:change_resource_record_sets,
                              resp[:change_info],
                              resp[:change_info][:id],
                              :config => config)
        end
      end

      protected

      def resource_identifiers
        [[:name, name], [:type, type], [:set_identifier, set_identifier]]
      end

      def get_resource attr_name = nil
        options = {}
        options[:hosted_zone_id] = hosted_zone_id
        options[:start_record_name] = name if name
        options[:start_record_type] = type if type
        options[:start_record_identifier] = set_identifier if set_identifier

        client.list_resource_record_sets(options)
      end
    end
  end
end
