namespace :deploy do
	desc "frist deploy + asset precompilation"
	task :with_assets do
		after "deploy:log_revision", "deploy:asset_precompile"
		invoke "deploy"
	end
	desc "frist deploy + bundle install (to vendor/bundle)"
	task :with_bundle_install do
		after "deploy:log_revision", "deploy:bundle_install"
		invoke "deploy"
	end
	desc "frist deploy + rails db migrate"
    task :with_migrate do
        after "deploy:log_revision", "deploy:migrate"
        invoke "deploy"
    end
	desc "frist deploy"
	task :with_all do
		after "deploy:add_batch_loader", "deploy:bundle_install"
		after "deploy:bundle_install", "deploy:asset_precompile"
		after "deploy:asset_precompile", "deploy:migrate"
		invoke "deploy"
	end
	task :with_init do
		after "deploy:add_batch_loader", "deploy:bundle_install"
		after "deploy:bundle_install", "deploy:asset_precompile"
		after "deploy:default_admin_set", "deploy:migrate"
		invoke "deploy"
	end
	desc "rails assets:precompile"
	task :asset_precompile do
		on roles(:app) do
			within release_path do #release_path is current path to our released project on the remote surver. 
				with rails_env: fetch(:rails_env) do
					execute(:bundle,:exec,:rails,"assets:precompile")
					# execute(:rails,"db:migrate")
				end
			end
		end			
	end
	desc "do: bundle install --path vendor/bundle"
	task :bundle_install do
		on roles(:app) do
			within release_path do #release_path is current path to our released project on the remote surver. 
				execute(:bundle, :install, "--path vendor/bundle", "--without development")
				# execute(:rails,"db:migrate")
			end
		end			
	end
	desc "rails db:migrate"
	task :migrate do
		on roles(:app) do
			within release_path do #release_path is current path to our released project on the remote surver. 
				with rails_env: fetch(:rails_env) do
					execute("bin/rails","db:migrate")
				end
			end
		end			
	end
	desc "bundle exec honeybadger install $HONEYBADGER_API_KEY"
	task :honey do
		on roles(:app) do
			within release_path do #release_path is current path to our released project on the remote surver. 
				with rails_env: fetch(:rails_env) do
					execute(:bundle, :exec, :honeybadger, :install, "$HONEYBADGER_API_KEY")
				end
			end
		end			
	end
end
