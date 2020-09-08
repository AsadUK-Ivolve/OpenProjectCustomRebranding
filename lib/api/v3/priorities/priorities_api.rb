#-- encoding: UTF-8
#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2020 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

require 'api/v3/priorities/priority_collection_representer'
require 'api/v3/priorities/priority_representer'

module API
  module V3
    module Priorities
      class PrioritiesAPI < ::API::OpenProjectAPI
        resources :priorities do
          after_validation do
            authorize(:view_work_packages, global: true)

            @priorities = IssuePriority.all
          end

          get do
            PriorityCollectionRepresenter.new(@priorities,
                                              api_v3_paths.priorities,
                                              current_user: current_user)
          end

          route_param :id, type: Integer, desc: 'Priority ID' do
            after_validation do
              @priority = IssuePriority.find(params[:id])
            end

            get do
              PriorityRepresenter.new(@priority, current_user: current_user)
            end
          end
        end
      end
    end
  end
end