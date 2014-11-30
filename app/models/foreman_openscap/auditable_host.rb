module ForemanOpenscap
  class AuditableHost < ActiveRecord::Base
    # Links Foreman's Host table with SCAPtimony's Asset table
    belongs_to :asset, :inverse_of => :auditable_host
    belongs_to_host :inverse_of => :auditable_host
  end
end