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

class ProctorConversationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :verify_messageable

  def initiate_conversation
    proctor = User.find(params[:proctor_id])
    student = User.find(params[:student_id])
    message = Conversation.build_message(proctor, params[:body])
    conversation = proctor.initiate_conversation([student], true, subject: params[:subject])
    conversation.add_message(message, update_for_sender: false, cc_author: true)
    render json: { status: :ok }
  end

  private

  def verify_messageable
    headers = {
      "Content-Type" => "application/json",
    }
    plugin = PluginSetting.find_by(name: "quiz_proctor")

    query = {
      student_id: params[:student_id],
      proctor_code: params[:proctor_code],
      unstarted: true,
    }.to_query

    quiz = HTTParty.get(
      "#{plugin.settings[:adhesion_url]}/api/proctored_exams?#{query}",
      headers: headers,
      # verify: false,
    )
    if quiz.parsed_response["error"].present?
      render json: { error: "Unauthorized" }
    end
  end
end
