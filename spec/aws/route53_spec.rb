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

require 'spec_helper'

module AWS
  describe Route53 do

    let(:config) { stub_config }

    let(:client) { config.route53_client }

    let(:route53) { Route53.new(:config => config) }

    it_behaves_like 'a class that accepts configuration', :route53

    shared_examples_for 'an route53 hosted zone collection' do |method, klass|

      it "should return an instance of #{klass}" do
        route53.send(method).should be_a(klass)
      end

      it 'should pass the config' do
        route53.send(method).config.should == route53.config
      end

    end

    context '#hosted_zones' do
      it_should_behave_like 'an route53 hosted zone collection',
        :hosted_zones, Route53::HostedZoneCollection
    end

  end
end
