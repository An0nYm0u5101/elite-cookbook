# -*- coding: utf-8 -*-
#
# Cookbook Name:: elite
# Resource:: git
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

actions :create

attribute :name, kind_of: String
attribute :user, kind_of: String, name_attribute: true
attribute :username, kind_of: String
attribute :email, kind_of: String
attribute :mode, kind_of: String, default: '0640'
attribute :cookbook, kind_of: String, default: 'elite'
attribute :gitconfig_src, kind_of: String, default: 'gitconfig.erb'
attribute :gitignore_src, kind_of: String, default: 'list2file.erb'
attribute :gitignore, kind_of: Array, default: ['*.a',
                                                '*.o',
                                                '*.py[co]',
                                                '*.so',
                                                '*.sw[nop]',
                                                '*~',
                                                '*.elc',
                                                '*.pyc',
                                                '.#*',
                                                '\#*\#',
                                                '.\#*',
                                                'auto-save-list',
                                                'tramp',
                                                '__pycache__',
                                                'bzr-orphans',
                                                '/.emacs.desktop',
                                                '/.emacs.desktop.lock',
                                                '/.project',
                                                '/.ropeproject']

def initialize(*args)
  super
  @action = :create
  @resource_name = :elite_git
end
