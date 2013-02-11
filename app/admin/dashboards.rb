ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1

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
        end
      end

      column do
        panel "Recent Users" do
          table_for User.order('created_at desc').limit(10).each do |user|
            column(:username) {|user| link_to(user.id, admin_user_path(user)) }
            column(:email)    {|user| "#{user.email}" }
          end
        end
      end

    end # columns

    columns do

      column do
        panel "Stats" do
          ul do
            li "#{Application.count} applications"
            li "#{Tracking.count} requests"
          end
          hr
          ul do
            li "#{User.count} users"
            li "#{Todo.count} todos"
          end
        end
      end

    end # columns

    # Define your dashboard sections here. Each block will be
    # rendered on the dashboard in the context of the view. So just
    # return the content which you would like to display.

    # The dashboard is organized in rows and columns, where each row
    # divides the space for its child columns equally.

    # To start a new row, open a new 'columns' block, and to start a
    # new column, open a new 'colum' block. That way, you can exactly
    # define the position for each content div.

    # == Simple Dashboard Column
    # Here is an example of a simple dashboard column
    #
    #   column do
    #     panel "Recent Posts" do
    #       content_tag :ul do
    #         Post.recent(5).collect do |post|
    #           content_tag(:li, link_to(post.title, admin_post_path(post)))
    #         end.join.html_safe
    #       end
    #     end
    #   end

    # == Render Partials
    # The block is rendererd within the context of the view, so you can
    # easily render a partial rather than build content in ruby.
    #
    #   column do
    #     panel "Recent Posts" do
    #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
    #     end
    #   end

  end # content
end
