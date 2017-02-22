ActiveSupport.on_load(:action_controller) do
  include Concerns::Whitelist
  include Concerns::ProctorQuizzes
end
