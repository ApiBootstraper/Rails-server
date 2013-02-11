class Api::V100::BasePresenter

  def set_current_user= user
    @@current_user = user
  end
  def current_user
    @@current_user
  end

protected
  @@current_user = {}
end