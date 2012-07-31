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
    class ChangeRequest
      def initialize(action, options={})
        @action = action
        @options = options
      end

      alias_method :rrset, :resource_record_set

      def build_query(options={})
        q = {}
        q[:action] = action
        q[:resource_record_set] = {}
        q[:resource_record_set][:name] = @options[:name]
        q[:resource_record_set][:type] = @options[:type]
        q[:resource_record_set][:set_identifier] = @options[:set_identifier]
        q[:resource_record_set][:weight] = @options[:weight]
        q[:resource_record_set][:region] = @options[:region]
        q[:resource_record_set][:ttl] = @options[:ttl]
        q[:resource_record_set][:resource_records] = @options[:resource_records]
        q[:resource_record_set][:alias_target] = @options[:alias_target]
        q
      end
    end

    class CreateRequest < Change
      def initialize(options={})
        super('CREATE', options)
      end
    end

    class DeleteRequest < Change
      def initialize(options={})
        super('DELETE', options)
      end
    end
  end
end
