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
require 'time'

module AWS
  class Route53
    describe HostedZone do

      let(:config) { stub_config }

      let(:client) { config.route53_client }

      let(:hosted_zone) { HostedZone.new('ABCDEF', :config => config) }

      let(:response) { client.stub_for(:get_hosted_zone) }

      let(:details) {{
        :id => '/hostedzone/ABCDEF',
        :name => 'example.com.',
        :caller_reference => "CreateHostedZone, ABCDEF, #{Time.now.httpdate}",
        :config => {
          :comment => 'this is an example.',
        },
        :resource_record_set_count => 108,
        :delegation_set => [
          'ns1.example.com.',
          'ns2.example.com.',
        ],
      }}

      let(:now) {
        Time.now
      }

      context '#id' do

        it 'returns plain id' do
          hosted_zone.id.should == details[:id].sub(%r!^/hostedzone/!, '')
        end

      end

      before(:each) do
        response.data = details
        client.stub(:get_hosted_zone).and_return(response)
      end

      shared_examples_for "hosted zone attribute" do |attr_name|

        it 'returns the attribute value' do
          hosted_zone.send(attr_name).should == details[attr_name]
        end

      end

      it_behaves_like "hosted zone attribute", :name
      it_behaves_like "hosted zone attribute", :caller_reference
      it_behaves_like "hosted zone attribute", :resource_record_set_count
      it_behaves_like "hosted zone attribute", :delegation_set

      context '#exists?' do

        it 'returns true if it can be described' do
          response.data = details # not empty
          hosted_zone.exists?.should == true
        end

        it 'returns false if it can not be found' do
          response.data = {} # empty
          hosted_zone.exists?.should == false
        end

      end

#     context '#delete' do

#       it 'calls #delete_alarms on the client' do
#         client.should_receive(:delete_alarms).
#           with(:alarm_names => [metric_alarm.name])
#         metric_alarm.delete
#       end

#     end

    end
  end
end
