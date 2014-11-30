require 'scaptimony/asset'

module ForemanOpenscap
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      has_one :auditable_host, :class_name => "ForemanOpenscap::AuditableHost",
              :foreign_key => :host_id, :inverse_of => :host
    end
  end
end
