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

    exam_request = HTTParty.get(
      "#{plugin.settings[:adhesion_proctor_url]}/api/proctored_exams?#{query}",
      headers: headers,
      # verify: false,
    ).parsed_response["exam_request"]

    if exam_request.nil?
      flash[:error] = "You do not have an exam that is ready to start."
      redirect_to proctored_exams_path
      return
    end

    matched_code = false
    proctor_id = nil
    proctor_name = nil
    code = params[:proctor_code]
    Account.find(exam_request["testing_center_id"]).users.find_each do |user|
      cd = CustomData.find_by(user: user, namespace: "edu.au.exam")
      if cd.nil? || cd.data["d"]["exam"]["proctor_code"] == code
        matched_code = true
        proctor_id = user.id
        proctor_name = user.name
      end
    end

    if !matched_code
      flash[:error] = "Invalid proctor code."
      redirect_to proctored_exams_path
      return
    end

    query = {
      proctor_id: proctor_id,
      proctor_name: proctor_name,
    }.to_query

    # HTTParty is really bad and sends the put body wrong, so i send everything in the params
    # RestClient does this better but I dont have RestClient so HTTParty it is.
    HTTParty.put(
      "#{plugin.settings[:adhesion_proctor_url]}/api/proctored_exams/#{exam_request['id']}?#{query}",
      body: {},
      headers: headers,
    ).parsed_response
    canvas_quiz = Quizzes::Quiz.find(exam_request["exam_id"])

    session[:is_proctored] = true
    session[:proctor_access_code] = canvas_quiz.access_code
    redirect_to course_quiz_take_path exam_request["course_id"], exam_request["exam_id"]
  end

  def finish_quiz
    headers = {
      "Content-Type" => "application/json",
    }
    plugin = PluginSetting.find_by(name: "quiz_proctor")

    query = {
      student_id: @current_user.id,
      update: true,
    }.to_query

    HTTParty.get(
      "#{plugin.settings[:adhesion_proctor_url]}/api/proctored_exams?#{query}",
      headers: headers,
      # verify: false
    )
    # we wont need to handle the response for this anyway, hence the hardcoded ok value
    # if it fails we will probably never know because the JavaScript
    # that will handle the response will have been reloaded by the time this finishes.
    render json: { status: "ok" }
  end
end
