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

class ProctorLoginController < ApplicationController
  include Login::Shared
  include Concerns::ValidateSignature
  before_action :validate_sigature

  def login
    # reset_session_for_login
    @user = User.find params[:user_id]
    pseudonym = Pseudonym.find_by(user_id: params[:user_id])
    @domain_root_account.pseudonym_sessions.create!(pseudonym, false)
    session[:is_proctored] = true
    redirect_to "/courses/#{params[:course_id]}/quizzes/#{params[:quiz_id]}/take"
  end

end
