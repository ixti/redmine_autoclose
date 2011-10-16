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

module RedmineAutoclose
  module Hooks
    class ModelIssueHook < Redmine::Hook::ViewListener
      def controller_issues_edit_after_save context={}
        issue = context[:issue]
        if issue.parent && child_status_id == issue.status_id && autoclose_parent?(issue)
          issue.parent.update_attributes :status_id => parent_status_id
        end
      end

      protected

      def autoclose_parent? issue
        # redmine uses awesome_nested_set - chidren contains ONLY direct childs
        issue.parent.children.all?{ |i| i.status_id == child_status_id }
      end

      # reduce route to the settings
      [:parent_status_id, :child_status_id].each do |key|
        class_eval <<-EOV
        def #{key}() Setting[:plugin_redmine_autoclose][:#{key}].to_i end
        EOV
      end
    end
  end
end
