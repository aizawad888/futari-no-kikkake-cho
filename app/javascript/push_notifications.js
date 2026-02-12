console.log('push_notifications.js が読み込まれました');

// VAPID 公開鍵（サーバー側の環境変数と一致させる）
const VAPID_PUBLIC_KEY = 'BLygwWz5QnXd2X7R3oKcl3t4Q9Hja1xdGsaSHmK_41U9Tl5RBhYHjnj0-LAAnSBqGHPmA0aBcNPemKxlFqGqWv4=';

// プッシュ通知の購読
async function subscribeToPushNotifications() {
  console.log('subscribeToPushNotifications が呼び出されました');

  // Service Worker がサポートされているか確認
  if (!('serviceWorker' in navigator)) {
    console.error('❌ Service Worker はサポートされていません');
    return;
  }

  if (!('PushManager' in window)) {
    console.error('❌ PushManager はサポートされていません');
    return;
  }

  console.log('✅ Service Worker と PushManager はサポートされています');

  try {
    console.log('⏳ Service Worker の準備を待っています...');
    
    // Service Worker の登録を待つ
    const registration = await navigator.serviceWorker.ready;
    console.log('✅ Service Worker 準備完了:', registration);

    // 既存の購読を確認
    console.log('⏳ 既存の購読を確認中...');
    let subscription = await registration.pushManager.getSubscription();

    if (subscription) {
      console.log('✅ 既に購読済み:', subscription);
      // 既存の購読情報をサーバーに送信（念のため）
      await sendSubscriptionToServer(subscription);
      return subscription;
    }

    console.log('⏳ 新規購読を開始します...');
    console.log('VAPID公開鍵:', VAPID_PUBLIC_KEY);

    // 新規購読
    subscription = await registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY)
    });

    console.log('✅ 新規購読成功:', subscription);

    // サーバーに購読情報を送信
    await sendSubscriptionToServer(subscription);

    return subscription;

  } catch (error) {
    console.error('❌ プッシュ通知の購読エラー:', error);
    console.error('エラー名:', error.name);
    console.error('エラーメッセージ:', error.message);
    console.error('スタックトレース:', error.stack);
    
    // エラーの詳細を出力
    if (error.name === 'NotAllowedError') {
      console.error('プッシュ通知の許可が拒否されました');
    } else if (error.name === 'NotSupportedError') {
      console.error('プッシュ通知はこのブラウザでサポートされていません');
    }
  }
}

// サーバーに購読情報を送信
async function sendSubscriptionToServer(subscription) {
  console.log('⏳ サーバーに購読情報を送信中...');
  
  try {
    const response = await fetch('/push_subscriptions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        subscription: subscription.toJSON()
      })
    });

    if (response.ok) {
      console.log('✅ 購読情報の保存成功');
    } else {
      console.error('❌ 購読情報の保存失敗:', response.status, response.statusText);
      const errorText = await response.text();
      console.error('エラー詳細:', errorText);
    }
  } catch (error) {
    console.error('❌ 購読情報の送信エラー:', error);
  }
}

// Base64文字列をUint8Arrayに変換
function urlBase64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding)
    .replace(/\-/g, '+')
    .replace(/_/g, '/');

  const rawData = window.atob(base64);
  const outputArray = new Uint8Array(rawData.length);

  for (let i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

// エクスポート
export { subscribeToPushNotifications };