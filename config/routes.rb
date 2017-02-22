Rails.application.routes.draw do
  get "proctor_login" => "proctor_login#login"
  get "proctored_exams" => "proctored_exams#show"
  post "proctored_exams" => "proctored_exams#start_quiz"
end
