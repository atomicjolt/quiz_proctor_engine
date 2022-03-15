# Copyright (C) 2017 Atomic Jolt

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module CatchProctoredExams
  extend ActiveSupport::Concern
  included do
    before_action :redirect_if_isolated
    before_action :isolate_exams
  end

  private

  def redirect_if_isolated
    if @current_user && params[:controller] != "proctored_exams" && session[:isolate_exams]
      session[:isolate_exams] = false
      redirect_to proctored_exams_path
    end
  end

  def isolate_exams
    if !@current_user && params[:controller] == "proctored_exams"
      session[:isolate_exams] = true
    end
  end
end
