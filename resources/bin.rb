# -*- coding: utf-8 -*-
#
# Cookbook Name:: elite
# Resource:: bin
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

resource_name :elite_bin
provides :elite_bin
default_action :create

property :script, String, name_property: true
property :owner, String
property :cookbook, String, default: 'elite'
property :source_dir, String, default: 'bin/'

def whyrun_supported?
  true
end

action :create do
  user = new_resource.owner

  cookbook_file "#{user_dotfiles(user)}/bin/#{new_resource.script}" do
    owner user
    group user_group(user)
    mode '0750'
    cookbook new_resource.cookbook
    source new_resource.source_dir + new_resource.script
  end
end
