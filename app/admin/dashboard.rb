ActiveAdmin.register_page "Dashboard" do
  
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  # https://github.com/gregbell/active_admin/issues/72
  content :title => proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do
        panel "Recent Todos" do
          table_for Todo.order('id desc').limit(10) do
            column("UUID")  {|t| link_to raw("<code>#{t.uuid[0,8]}...</code>"), admin_tracking_path(t), :title => t.uuid }
            column :name
            column("User")  {|t| link_to "#{t.user.username}", admin_user_path(t.user) }
          end

          para "&raquo; #{link_to "see all", admin_todos_path}".html_safe
        end
      end

      column do
        panel "Recent Users" do
          table_for User.order('created_at desc').limit(10).each do |u|
            column(:username) {|u| link_to(u.id, admin_user_path(u)) }
            column :email
            column("Active?") {|u| status_tag(u.is_enable? ? "Yes" : "No", u.is_enable? ? "ok" : "error") }
          end

          para "&raquo; #{link_to "see all", admin_users_path}".html_safe
        end
      end

      column do
        panel "Latest disabled Users" do
          table_for User.disabled.order('updated_at desc').limit(10).each do |u|
            column(:username) {|u| link_to(u.id, admin_user_path(u)) }
            column :email
            column :updated_at
          end

          para "&raquo; #{link_to "see all", admin_users_path(:q => {:is_enable_eq => false})}".html_safe
        end
      end

    end # columns

    columns do

      column do
        panel "Stats" do
          ul do
            li "<strong>#{Tracking.where("created_at >= ?", Time.now.at_beginning_of_day).count}</strong> requests this day".html_safe
            li "<strong>#{Tracking.where("created_at >= ?", Time.now.at_beginning_of_month).count}</strong> requests this week".html_safe
            li "<strong>#{Tracking.where("created_at >= ?", Time.now.at_beginning_of_year).count}</strong> requests this year".html_safe
            li "<strong>#{Tracking.count}</strong> requests registered".html_safe
          end
        end
      end

      column do
        panel "Stats" do
          ul do
            li "<strong>#{Application.count}</strong> #{link_to "applications", admin_applications_path}".html_safe
            li "<strong>#{User.count}</strong> #{link_to "users", admin_users_path}".html_safe
            li "<strong>#{Todo.count}</strong> #{link_to "todos", admin_todos_path}".html_safe
          end
        end
      end

    end # columns

  end # content
end
