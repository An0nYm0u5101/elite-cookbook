# -*- coding: utf-8 -*-
#
# Cookbook Name:: elite
# Spec:: dotfiles
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chefspec'
require 'chefspec/berkshelf'

describe 'elite::dotfiles' do
  let(:subject) do
    ChefSpec::SoloRunner.new(platform: 'debian',
                             version: '8.0') do |node|
      node.override['elite']['groups'] = %w(elite)
      node.override['elite']['users'] = %w(sliim)
      node.override['elite']['sliim'] = {
        'dotfd' => '/home/sliim/.stuff',
        'shell' => '/bin/bash',
        'group' => 'elite',
        'groups' => %w(elite),
        'password' => nil,
      }
    end.converge(described_recipe)
  end

  it 'includes recipe[elite::default]' do
    expect(subject).to include_recipe('elite::default')
  end

  it 'creates directory[/home/sliim/.stuff]' do
    expect(subject).to create_directory('/home/sliim/.stuff')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0750',
            recursive: true)
  end

  context 'without dotfd' do
    let(:subject) do
      ChefSpec::SoloRunner.new(platform: 'debian',
                               version: '8.0') do |node|
        node.override['elite']['groups'] = %w(elite)
        node.override['elite']['users'] = %w(sliim)
        node.override['elite']['sliim'] = {
          'group' => 'elite',
          'shell' => '/bin/bash',
          'groups' => %w(elite),
          'password' => nil,
        }
      end.converge(described_recipe)
    end

    it 'creates directory[/home/sliim/.dotfiles]' do
      expect(subject).to create_directory('/home/sliim/.dotfiles')
        .with(owner: 'sliim',
              group: 'elite',
              mode: '0750',
              recursive: true)
    end
  end
end
