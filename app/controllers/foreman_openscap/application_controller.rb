module ForemanOpenscap
  class ApplicationController < ::ApplicationController

     def search_name
       "openscap_#{controller_name}"
     end
  end
end