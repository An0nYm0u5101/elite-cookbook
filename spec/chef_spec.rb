# -*- coding: utf-8 -*-
#
# Cookbook Name:: elite
# Spec:: chef
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

require_relative 'spec_helper'

describe 'elite::chef' do
  let(:subject) do
    ChefSpec::SoloRunner.new(step_into: %w(elite_chef),
                             platform: 'debian',
                             version: '9.0') do |node|
      node.override['elite']['users'] = %w(sliim foo)
      node.override['elite']['groups'] = %w(elite)
      node.override['elite']['sliim']['name'] = 'Sliim'
      node.override['elite']['sliim']['email'] = 'sliim@mailoo.org'
      node.override['elite']['sliim']['home'] = '/home/sliim'
      node.override['elite']['sliim']['group'] = 'elite'
      node.override['elite']['sliim']['groups'] = %w(elite)
      node.override['elite']['sliim']['dotfd'] = '/home/sliim/.dotfiles'
      node.override['elite']['sliim']['chef']['cookbook'] = 'elite'
      node.override['elite']['sliim']['chef']['client_source'] = 'chef/knife.rb.erb'
      node.override['elite']['sliim']['chef']['stove_source'] = 'chef/stove.erb'
      node.override['elite']['sliim']['chef']['client_key_path'] = '/path/to/key'
      node.override['elite']['sliim']['chef']['node_name'] = 'nodename'
      node.override['elite']['sliim']['chef']['chef_server_url'] = 'https://my.chef.server/org/spec'
    end.converge(described_recipe)
  end

  it 'creates elite_chef[sliim]' do
    expect(subject).to create_elite_chef('sliim')
      .with(mode: '0640',
            cookbook: 'elite',
            client_source: 'chef/knife.rb.erb',
            stove_source: 'chef/stove.erb',
            client_key_path: '/path/to/key',
            node_name: 'nodename',
            chef_server_url: 'https://my.chef.server/org/spec')
  end

  it 'creates directory[/home/sliim/.dotfiles/chef]' do
    expect(subject).to create_directory('/home/sliim/.dotfiles/chef')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0750')
  end

  it 'creates template[/home/sliim/.dotfiles/chef/knife.rb]' do
    config_file = '/home/sliim/.dotfiles/chef/knife.rb'
    matches = [start_with('# Generated by Chef!'),
               /^node_name\s+'nodename'$/,
               %r{^chef_server_url\s+'https://my.chef.server/org/spec'},
               %r{^client_key\s+'/path/to/key'}]

    expect(subject).to create_template(config_file)
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0640',
            cookbook: 'elite',
            source: 'chef/knife.rb.erb')

    matches.each do |m|
      expect(subject).to render_file(config_file).with_content(m)
    end
  end

  it 'creates template[/home/sliim/.dotfiles/stove]' do
    config_file = '/home/sliim/.dotfiles/stove'
    expect(subject).to create_template(config_file)
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0640',
            cookbook: 'elite',
            source: 'chef/stove.erb')

    expect(subject).to render_file(config_file).with_content(
      start_with('{"username":"nodename","key":"/path/to/key"}'))
  end

  it 'creates elite_dotlink[sliim-chef]' do
    expect(subject).to create_elite_dotlink('sliim-chef')
      .with(owner: 'sliim',
            file: 'chef')
  end

  it 'creates elite_dotlink[sliim-stove]' do
    expect(subject).to create_elite_dotlink('sliim-stove')
      .with(owner: 'sliim',
            file: 'stove')
  end
end
