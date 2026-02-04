self.addEventListener('push', (event) => {
  console.log('プッシュ通知を受信しました:', event);
  
  try {
    const data = event.data.json();
    console.log('受信データ:', data);
    
    const options = {
      body: data.body,
      data: {
        url: data.url
      }
    };
    
    console.log('通知を表示します:', data.title, options);
    
    // 通知を表示
    event.waitUntil(
      self.registration.showNotification(data.title, options)
        .then(() => {
          console.log('✅ 通知の表示に成功しました');
        })
        .catch((error) => {
          console.error('❌ 通知の表示に失敗しました:', error);
        })
    );
  } catch (error) {
    console.error('❌ エラーが発生しました:', error);
  }
});

// 通知をクリックしたときの処理
self.addEventListener('notificationclick', (event) => {
  console.log('通知がクリックされました:', event);
  
  event.notification.close();
  
  const urlToOpen = event.notification.data.url || '/';
  
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      for (const client of clientList) {
        if (client.url === urlToOpen && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(urlToOpen);
      }
    })
  );
});