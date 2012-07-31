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
    class ChangeBatch
      def initialize(comment=nil)
        @comment = comment
        @changes = []
      end

      attr_reader :changes

      attr_reader :comment

      def push(change)
        @changes.push(change)
      end

      alias_method :<<, :push

      def build_query(options={})
        q = {}
        q[:hosted_zone_id] = options[:hosted_zone_id]
        q[:change_batch] = {}
        q[:change_batch][:comment] = comment if comment
        q[:change_batch][:changes] = []
        @changes.each { |change|
          q[:change_batch][:changes] << change.build_query(options)
        }
        q
      end
    end
  end
end
