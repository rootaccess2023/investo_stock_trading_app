class ApplicationController < ActionController::Base
    def after_sign_in_path_for(resource)
        if resource.has_role?(:admin)
            admin_users_path
        else
            trader_dashboard_path
        end
    end
end
