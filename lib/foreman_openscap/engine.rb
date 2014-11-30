require 'deface'
require 'foreman_openscap/engine'

module ForemanOpenscap
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_openscap.load_app_instance_data' do |app|
      app.config.paths['db/migrate'] += Scaptimony::Engine.paths['db/migrate'].existent
      app.config.paths['db/migrate'] += ForemanOpenscap::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_openscap.assets.precompile' do |app|
      app.config.assets.precompile += %w(
        'foreman_openscap/policy_edit.js'
      )
    end

    initializer 'foreman_openscap.configure_assets', :group => :assets do
      SETTINGS[:foreman_openscap] =
        { :assets => { :precompile => ['foreman_openscap/policy_edit.js'] } }
    end

    initializer 'foreman_openscap.register_plugin', :after => :finisher_hook do |app|
      Foreman::Plugin.register :foreman_openscap do
        requires_foreman '>= 1.5'

        # Add permissions
        security_block :foreman_openscap do
          permission :view_arf_reports, { 'openscap/arf_reports'   => [:index, :show],
                                          'openscap/policies'      => [:index, :show],
                                          'openscap/scap_contents' => [:index, :show],
                                      }
          permission :edit_compliance, { 'openscap/arf_reports'   => [:destroy],
                                         'openscap/policies'      => [:new, :create, :edit, :update, :destroy],
                                         'openscap/scap_contents' => [:new, :create, :edit, :update]
                                     }
        end

        role 'View compliance reports', [:view_arf_reports]
        role 'Edit compliance policies', [:edit_compliance]

        #add menu entries
        divider :top_menu, :caption => N_('Compliance'), :parent => :hosts_menu
        menu :top_menu, :compliance_policies, :caption => N_('Policies'),
             :url_hash                                 => { :controller => :'foreman_openscap/policies', :action => :index },
             :parent                                   => :hosts_menu
        menu :top_menu, :compliance_contents, :caption => N_('SCAP contents'),
             :url_hash                                 => { :controller => :'foreman_openscap/scap_contents', :action => :index },
             :parent                                   => :hosts_menu
        menu :top_menu, :compliance_reports, :caption => N_('Reports'),
             :url_hash                                => { :controller => :'foreman_openscap/arf_reports', :action => :index },
             :parent                                  => :hosts_menu
      end
    end

    #Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanOpenscap::HostExtensions)
        ::Scaptimony::ArfReport.send(:include, ForemanOpenscap::ArfReportExtensions)
        ::Scaptimony::Policy.send(:include, ForemanOpenscap::PolicyExtensions)
        ::Scaptimony::ScapContent.send(:include, ForemanOpenscap::ScapContentExtensions)
      rescue => e
        puts "ForemanOpenscap: skipping engine hook (#{e.to_s})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        Scaptimony::Engine.load_seed
        ForemanOpenscap::Engine.load_seed
      end
    end

  end
end
