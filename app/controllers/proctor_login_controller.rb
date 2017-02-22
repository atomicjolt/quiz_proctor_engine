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
