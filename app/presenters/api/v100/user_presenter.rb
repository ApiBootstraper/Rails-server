class Api::V100::UserPresenter < Api::V100::BasePresenter

  def collection collection
    formated_users = []
    collection.each do |u|
      formated_users.push({
        :uuid       => u.uuid,
        :username   => u.username,
        :email      => nil, #u.email,
        :created_at => u.created_at,
      })
    end
    return formated_users
  end

  def single user
    {
      :uuid       => user.uuid,
      :username   => user.username,
      :email      => nil, #user.email,
      :created_at => user.created_at,
    }
  end

  def single_for_current_user current_user
    {
      :uuid       => current_user.uuid,
      :username   => current_user.username,
      :email      => current_user.email,
      :created_at => current_user.created_at,
    }
  end

end