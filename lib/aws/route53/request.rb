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

    # @private
    class Request < Core::Http::Request

      include Core::Signature::Version3

      def add_authorization! credentials

        headers["x-amz-date"] ||= (headers["date"] ||= Time.now.httpdate)
        headers["host"] ||= host

        headers["x-amz-security-token"] = credentials.session_token if 
          credentials.session_token

        # compute the authorization
        headers["x-amzn-authorization"] =
          (@use_ssl ? "AWS3-HTTPS " : "AWS3 ") +
          "AWSAccessKeyId=#{credentials.access_key_id},"+
          "Algorithm=HmacSHA256,"+
          "Signature=#{sign(credentials.secret_access_key, string_to_sign)}"
      end

      def string_to_sign
        headers['date']
      end

    end

  end
end
