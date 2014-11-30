module ForemanOpenscap
  class PoliciesController < ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :find_resource, :only => [:show, :edit, :update, :destroy]

    def index
      @policies = resource_base.search_for(params[:search])
    end

    def new
      @policy = ::Scaptimony::Policy.new
    end

    def show
      self.response_body = ::Scaptimony::GuideGenerator.new @policy
    end

    def create
      @policy = ::Scaptimony::Policy.new(params[:policy])
      if @policy.save
        process_success
      else
        process_error
      end
    end

    def update
      if @policy.update_attributes(params[:policy])
        process_success
      else
        process_error
      end
    end

    def destroy
      if @policy.destroy
        process_success
      else
        process_error
      end
    end

    def scap_content_selected
      if params[:scap_content_id] && (@scap_content = ::Scaptimony::ScapContent.find(params[:scap_content_id]))
        @policy ||= ::Scaptimony::Policy.new
        render :partial => 'scap_content_results', :locals => { :policy => @policy }
      end
    end

  end
end
