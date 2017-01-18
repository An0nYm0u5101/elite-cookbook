# -*- coding: utf-8 -*-
#
# Cookbook Name:: elite
# Spec:: zsh
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

describe 'elite::zsh' do
  let(:subject) do
    ChefSpec::SoloRunner.new(step_into: %w(elite_zsh elite_zsh_plugin
                                           elite_zsh_theme elite_zsh_completion),
                             platform: 'debian',
                             version: '8.0') do |node|
      node.override['elite']['users'] = %w(sliim foo)
      node.override['elite']['groups'] = %w(elite)
      node.override['elite']['sliim']['name'] = 'Sliim'
      node.override['elite']['sliim']['email'] = 'sliim@mailoo.org'
      node.override['elite']['sliim']['home'] = '/home/sliim'
      node.override['elite']['sliim']['group'] = 'elite'
      node.override['elite']['sliim']['groups'] = %w(elite)
      node.override['elite']['sliim']['dotfd'] = '/home/sliim/.dotfiles'
      node.override['elite']['sliim']['zsh']['cookbook'] = 'elite'
      node.override['elite']['sliim']['zsh']['plugins'] = %w(plugin1 plugin2 plugin3)
      node.override['elite']['sliim']['zsh']['completions'] = %w(comp1 comp2 comp3)
      node.override['elite']['sliim']['zsh']['theme'] = 'mytheme'
      node.override['elite']['sliim']['zsh']['config']['color1'] = '012'
      node.override['elite']['sliim']['zsh']['config']['color2'] = '345'
      node.override['elite']['sliim']['zsh']['config']['pyenv_prompt'] = true
      node.override['elite']['sliim']['zsh']['config']['rbenv_prompt'] = true
      node.override['elite']['sliim']['zsh']['config']['ndenv_prompt'] = true
    end.converge(described_recipe)
  end

  it 'includes recipe[elite::default]' do
    expect(subject).to include_recipe('elite::default')
  end

  it 'creates elite_zsh[sliim]' do
    expect(subject).to create_elite_zsh('sliim')
      .with(cookbook: 'elite')
  end

  it 'installs package[zsh]' do
    expect(subject).to install_package('zsh')
  end

  it 'creates template[/home/sliim/.dotfiles/zshrc]' do
    config_file = '/home/sliim/.dotfiles/zshrc'
    matches = [start_with('# Generated by Chef!'),
               /^plugins=\(plugin1 plugin2 plugin3\)$/,
               /^completion=\(comp1 comp2 comp3\)$/,
               /^pyenv_prompt=true$/,
               /^rbenv_prompt=true$/,
               /^ndenv_prompt=true$/,
               /^shell_color1=012$/,
               /^shell_color2=345$/,
               /^theme=mytheme$/]

    expect(subject).to create_template(config_file)
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0640',
            source: 'zshrc.erb')

    matches.each do |m|
      expect(subject).to render_file(config_file).with_content(m)
    end
  end

  it 'creates directory[/home/sliim/.dotfiles/zsh.d]' do
    expect(subject).to create_directory('/home/sliim/.dotfiles/zsh.d')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0750')
  end

  it 'creates cookbook_file[/home/sliim/.dotfiles/zsh.d/init.zsh]' do
    expect(subject).to create_cookbook_file('/home/sliim/.dotfiles/zsh.d/init.zsh')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0640',
            source: 'zsh.d/init.zsh')
  end

  it 'creates remote_directory[/home/sliim/.dotfiles/zsh.d/lib]' do
    expect(subject).to create_remote_directory('/home/sliim/.dotfiles/zsh.d/lib')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0750',
            files_owner: 'sliim',
            files_group: 'elite',
            files_mode: '0640',
            source: 'zsh.d/lib')
  end

  it 'creates directory[/home/sliim/.dotfiles/zsh.d/plugins]' do
    expect(subject).to create_directory('/home/sliim/.dotfiles/zsh.d/plugins')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0750')
  end

  %w(plugin1 plugin2 plugin3).each do |p|
    it "creates elite_zsh_plugin[sliim-#{p}]" do
      expect(subject).to create_elite_zsh_plugin("sliim-#{p}")
    end

    it "creates cookbook_file[/home/sliim/.dotfiles/zsh.d/plugins/#{p}.plugin.zsh]" do
      expect(subject).to create_cookbook_file("/home/sliim/.dotfiles/zsh.d/plugins/#{p}.plugin.zsh")
        .with(owner: 'sliim',
              group: 'elite',
              mode: '0640',
              source: "zsh.d/plugins/#{p}.plugin.zsh",
              cookbook: 'elite')
    end
  end

  it 'creates directory[/home/sliim/.dotfiles/zsh.d/completions]' do
    expect(subject).to create_directory('/home/sliim/.dotfiles/zsh.d/completions')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0750')
  end

  %w(comp1 comp2 comp3).each do |c|
    it "creates elite_zsh_completion[sliim-#{c}]" do
      expect(subject).to create_elite_zsh_completion("sliim-#{c}")
    end

    it "creates cookbook_file[/home/sliim/.dotfiles/zsh.d/completions/_#{c}]" do
      expect(subject).to create_cookbook_file("/home/sliim/.dotfiles/zsh.d/completions/_#{c}")
        .with(owner: 'sliim',
              group: 'elite',
              mode: '0640',
              source: "zsh.d/completions/_#{c}",
              cookbook: 'elite')
    end
  end

  it 'creates directory[/home/sliim/.dotfiles/zsh.d/themes]' do
    expect(subject).to create_directory('/home/sliim/.dotfiles/zsh.d/themes')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0750')
  end

  it 'creates elite_zsh_theme[sliim-mytheme]' do
    expect(subject).to create_elite_zsh_theme('sliim-mytheme')
  end

  it 'creates cookbook_file[/home/sliim/.dotfiles/zsh.d/themes/mytheme.theme.zsh]' do
    expect(subject).to create_cookbook_file('/home/sliim/.dotfiles/zsh.d/themes/mytheme.theme.zsh')
      .with(owner: 'sliim',
            group: 'elite',
            mode: '0640',
            source: 'zsh.d/themes/mytheme.theme.zsh',
            cookbook: 'elite')
  end

  it 'creates elite_dotlink[zshrc]' do
    expect(subject).to create_elite_dotlink('zshrc')
  end

  it 'creates elite_dotlink[zsh.d]' do
    expect(subject).to create_elite_dotlink('zsh.d')
  end
end
