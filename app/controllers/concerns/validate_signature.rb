module Concerns::ValidateSignature
  extend ActiveSupport::Concern

  def validate_sigature
    raise "Invalid Signature " if !params[:signature]
    plugin = PluginSetting.find_by(name: "quiz_proctor")
    verifier = ActiveSupport::MessageVerifier.new plugin.settings[:proctor_secret]
    verifier.verify(params[:signature])
  end
end
