set :job_template, "TZ=Asia/Tokyo bash -l -c ':job'"

# 0時に記念日通知を送信 アプリ内通知
every 1.day, at: "12:00 am" do
  runner "AnniversaryNotificationCreator.call"
end

# 0時5分に記念日通知を送信 プッシュ通知(アプリ内通知作成後)
every 1.day, at: "12:05 am" do
  runner "SendDailyPushNotificationsJob.perform_later('anniversary')"
end

# 21時に新規投稿の1日1回通知を送信
every 1.day, at: "8:00 pm" do
  runner "SendDailyPushNotificationsJob.perform_later('new_post')"
end
