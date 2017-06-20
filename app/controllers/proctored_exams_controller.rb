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

require "httparty"

class ProctoredExamsController < ApplicationController
  layout "borderless_lti"
  before_action :require_user

  def show; end

  def start_quiz
    headers = {
      "Content-Type" => "application/json",
    }
    plugin = PluginSetting.find_by(name: "quiz_proctor")

    query = {
      student_id: @current_user.id,
      proctor_code: params[:proctor_code],
    }.to_query

    quiz = HTTParty.get(
      "#{plugin.settings[:adhesion_url]}/api/proctored_exams?#{query}",
      headers: headers,
      verify: false,
    )
    if quiz.parsed_response["error"].present?
      flash[:error] = quiz.parsed_response["error"]
      redirect_to proctored_exams_path
    else
      quiz = quiz.parsed_response
      session[:is_proctored] = true
      session[:proctor_access_code] = quiz["proctor_access_code"]
      redirect_to course_quiz_take_path quiz["quiz"]["course_id"], quiz["quiz"]["exam_id"]
    end
  end

  def finish_quiz
    headers = {
      "Content-Type" => "application/json",
    }
    plugin = PluginSetting.find_by(name: "quiz_proctor")

    query = {
      student_id: @current_user.id,
      update: true
    }.to_query

    HTTParty.get(
      "#{plugin.settings[:adhesion_url]}/api/proctored_exams?#{query}",
      headers: headers,
      verify: false
    )
    # we wont need to handle the response for this anyway, hence the hardcoded ok value
    # if it fails we will probably never know because the JavaScript
    # that will handle the response will have been reloaded by the time this finishes.
    render json: {status: "ok"}
  end
end
