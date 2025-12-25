class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
                                  .includes(:notifiable)  # N+1対策
                                  .order(created_at: :desc)
    # .page(params[:page])
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read_at: Time.current) unless notification.read?

    # 投稿詳細にリダイレクト
    redirect_to notification.notifiable || notifications_path
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    head :ok
  end
end
