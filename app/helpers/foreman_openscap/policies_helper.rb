module ForemanOpenscap
  module PoliciesHelper
    def profiles_selection
      return @scap_content.scap_content_profiles unless @scap_content.blank?
      return @policy.scap_content.scap_content_profiles unless @policy.scap_content.blank?
      []
    end
  end
end