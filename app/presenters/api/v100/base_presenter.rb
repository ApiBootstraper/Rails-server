class Api::V100::BasePresenter

protected
  @@current_user = {}

  def set_current_user= user
    @@current_user = user
  end
  def current_user
    @@current_user
  end
end