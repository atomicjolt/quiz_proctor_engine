require "httparty"

class ProctoredExamsController < ApplicationController

  layout "borderless_lti"

  def show; end

  def start_quiz
    headers = {
      "Content-Type" => "application/json",
    }
    plugin = PluginSetting.find_by(name: "quiz_proctor")

    query = {
      student_id: @current_user.id,
      proctor_code: params[:proctor_code],
      oauth_consumer_key: "exams",
    }.to_query

    quiz = HTTParty.get(
      "#{plugin.settings[:adhesion_url]}/api/proctored_exams?#{query}",
      headers: headers,
      # verify: false,
    )

    if quiz.parsed_response["error"].present?
      flash[:error] = quiz.parsed_response["error"]
      redirect_to proctored_exams_path
    else
      session[:is_proctored] = true
      redirect_to course_quiz_take_path quiz.parsed_response["course_id"], quiz.parsed_response["exam_id"]
    end
  end
end
