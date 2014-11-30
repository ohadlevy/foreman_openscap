module ForemanOpenscap
  class ArfReportsController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_resource, :only => [:show, :destroy]

    def index
      @arf_reports = resource_base.search_for(params[:search], :order => params[:order]).paginate(:page => params[:page], :per_page => params[:per_page])
    end

    def show
      self.response_body = @arf_report
    end

    def destroy
      if @arf_report.destroy
        process_success
      else
        process_error
      end
    end
  end
end
