module ForemanOpenscap
  class ScapContentsController < ForemanOpenscap::ApplicationController
    include Foreman::Controller::AutoCompleteSearch
    before_filter :handle_file_upload, :only => [:create]
    before_filter :find_resource, :only => [:show, :edit, :update]

    def index
      @contents = resource_base.search_for(params[:search])
    end

    def show
      send_data @scaptimony_scap_content.scap_file,
                :type     => 'application/xml',
                :filename => @scaptimony_scap_content.original_filename
    end

    def new
      @scaptimony_scap_content = ::Scaptimony::ScapContent.new
    end

    # POST /foreman_openscap/scap_contents
    def create
      @scaptimony_scap_content = ::Scaptimony::ScapContent.new(params[:scap_content])
      if @scaptimony_scap_content.save
        process_success
      else
        process_error
      end
    end

    def update
      if @scaptimony_scap_content.update_attributes(params[:scap_content])
        process_success
      else
        process_error
      end
    end

    private
    def handle_file_upload
      return unless params[:scap_content] && (t = params[:scap_content][:scap_file])
      params[:scap_content][:original_filename] = t.original_filename
      params[:scap_content][:scap_file]         = t.read if t.respond_to?(:read)
    end

    def model_of_controller
      Scaptimony::ScapContent
    end

    def resource_class
      model_of_controller
    end
  end
end
