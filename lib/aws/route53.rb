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

require 'aws/core'
require 'aws/route53/config'

module AWS
  class Route53

    AWS.register_autoloads(self, 'aws/route53') do
      autoload :Change, 'change'
#     autoload :ChangeCollection, 'change_collection'
      autoload :Client, 'client'
      autoload :Errors, 'errors'
      autoload :HostedZone, 'hosted_zone'
      autoload :HostedZoneCollection, 'hosted_zone_collection'
      autoload :Request, 'request'
#     autoload :ResourceRecord, 'resource_record'
#     autoload :ResourceRecordCollection, 'resource_record_collection'
    end

    include Core::ServiceInterface

    # @return [HostedZoneCollection]
    def hosted_zones
      HostedZoneCollection.new(:config => config)
    end
  end
end
