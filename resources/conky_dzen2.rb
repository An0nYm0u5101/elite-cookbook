# -*- coding: utf-8 -*-
#
# Cookbook Name:: elite
# Resource:: conky_dzen2
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

resource_name :elite_conky_dzen2
provides :elite_conky_dzen2
default_action :create

property :user, String, name_property: true
property :config, Hash, default: { 'default_color' => 'FFFFFF',
                                   'color1' => 'FFFFFF',
                                   'color2' => 'AAAAAA',
                                   'color3' => '777777',
                                   'color4' => '444444',
                                 }

property :interface_type_blacklist, Array, default: []

def whyrun_supported?
  true
end

action :create do
  user = new_resource.user

  template "#{user_dotfiles(user)}/conky.d/dzen2" do
    owner user
    group user_group(user)
    mode '0640'
    source 'conky.d/dzen2.erb'
    cookbook 'elite'
    variables conky: new_resource.config,
              interface_type_blacklist: new_resource.interface_type_blacklist,
              home: user_home(user)
  end

  cookbook_file "#{user_dotfiles(user)}/conky.d/scripts/battery-notify.sh" do
    owner user
    group user_group(user)
    mode '0750'
    source 'conky.d/scripts/battery-notify.sh'
    cookbook 'elite'
  end
end
