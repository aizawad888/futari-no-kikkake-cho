module ApplicationHelper
  def show_footer?
    # フッターを非表示にしたいコントローラーのリスト
    excluded_controllers = [
      "devise/registrations",
      "devise/sessions",
      "users/registrations",
      "users/sessions",
      "onboarding/pairs"
    ]
    
    !controller_path.in?(excluded_controllers)
  end
end