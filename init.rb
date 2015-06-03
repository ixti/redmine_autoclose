# This file is a part of redmine_autoclose
# redMine plugin, that auto-closes parent issue.
#
# Copyright (c) 2011 Aleksey V Zapparov AKA ixti
#
# redmine_autoclose is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_autoclose is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_autoclose.  If not, see <http://www.gnu.org/licenses/>.


require 'redmine'


Redmine::Plugin.register :redmine_autoclose do
  name        'redmine_autoclose'
  author      'Aleksey V Zapparov AKA "ixti"'
  description 'Auto-close parent issue, when childs got closed.'
  version     '0.0.3'
  url         'https://github.com/ixti/redmine_autoclose/'
  author_url  'http://www.ixti.ru/'

  requires_redmine :version_or_higher => '2.0.0'

  settings :default => {
    :child_status_id => 0,
    :parent_status_id => 0
  }, :partial => 'autoclose/settings'
end

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'issue'
  unless Issue.included_modules.include?(RedmineAutoclose::Patches::IssuePatch)
    Issue.send(:include, RedmineAutoclose::Patches::IssuePatch)
  end
end