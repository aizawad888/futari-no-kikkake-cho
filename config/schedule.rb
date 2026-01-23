set :job_template, "TZ=Asia/Tokyo bash -l -c ':job'"

every 1.day, at: "12:00 am" do
  runner "AnniversaryNotificationCreator.call"
end
