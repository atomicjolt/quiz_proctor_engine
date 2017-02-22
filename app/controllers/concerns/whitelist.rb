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

module Concerns::Whitelist
  extend ActiveSupport::Concern
  include Login::Shared
  included do
    before_action :check_whitelist
  end

  private

  def check_whitelist
    whitelist = %w{
      quizzes/quiz_submissions
      quizzes/quiz_submission_events_api
      quizzes/quizzes
      conversations
      courses
      context_module_items_api
      proctored_exams
      proctor_login
    }
    if session[:is_proctored] && !whitelist.include?(params[:controller])
      puts "======================================="
      puts params[:controller]
      puts "======================================="
      reset_session_for_login
      redirect_to :login
    end
  end
end

# "controller"=>"quizzes/quiz_submissions", "action"=>"backup"
# "controller"=>"quizzes/quiz_submission_events_api", "action"=>"create"
# "controller"=>"quizzes/quizzes", "action"=>"show",
# "controller"=>"conversations", "action"=>"unread_count"
# "controller"=>"courses", "action"=>"ping"
# "controller"=>"quizzes/quizzes", "action"=>"submission_versions"
# "controller"=>"quizzes/quiz_submissions", "action"=>"create"
# "controller"=>"quizzes/quiz_submissions", "action"=>"record_answer"
# "controller"=>"context_module_items_api", "action"=>"item_sequence"
