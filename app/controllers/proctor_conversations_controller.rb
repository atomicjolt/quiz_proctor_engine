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

class ProctorConversationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def initiate_conversation
    proctor = User.find(params[:proctor_id])
    cd = CustomData.find_by(user: proctor, namespace: "edu.au.exam")
    if cd.nil? || params[:proctor_code] != cd.data["d"]["exam"]["proctor_code"]
      render json: { error: "Unauthorized"}
    end
    student = User.find(params[:student_id])
    message = Conversation.build_message(proctor, params[:body])
    conversation = proctor.initiate_conversation([student], true, subject: params[:subject])
    conversation.add_message(message, update_for_sender: false, cc_author: true)
    render json: { status: :ok }
  end

end
