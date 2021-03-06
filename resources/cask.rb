# -*- coding: utf-8 -*-
#
# Cookbook Name:: elite
# Resource:: cask
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

resource_name :elite_cask
provides :elite_cask
default_action :create

property :user, String, name_property: true
property :repository, String, default: 'https://github.com/cask/cask.git'
property :reference, String, default: 'master'

def whyrun_supported?
  true
end

action :create do
  user = new_resource.user

  git "#{user_home(user)}/.cask" do
    user user
    group user_group(user)
    repository new_resource.repository
    reference new_resource.reference
    action :sync
  end
end
