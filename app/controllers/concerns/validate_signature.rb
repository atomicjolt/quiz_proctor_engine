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

module ValidateSignature
  extend ActiveSupport::Concern

  def validate_sigature
    raise "Invalid Signature " if !params[:signature]
    plugin = PluginSetting.find_by(name: "quiz_proctor")
    verifier = ActiveSupport::MessageVerifier.new plugin.settings[:proctor_secret]
    verified = verifier.verify(params[:signature])
    verified && Time.now.to_i - params[:date].to_i < 30
  end
end
