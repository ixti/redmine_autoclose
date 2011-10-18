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

require_dependency 'issue'

module RedmineAutoclose
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          after_save do |issue|
            issue.parent.update_attributes({
              :status_id => RedmineAutoclose::parent_status_id
            }) if issue.should_autoclose_parent?
          end
        end
      end

      module InstanceMethods
        def should_autoclose_parent?
          # skip real calculation on root issue or status mismatch
          return false unless parent && RedmineAutoclose::child_status_id == status_id
          # redmine uses awesome_nested_set - chidren contains ONLY direct childs
          parent.children.all?{ |i| i.status_id == RedmineAutoclose::child_status_id }
        end
      end
    end
  end
end
