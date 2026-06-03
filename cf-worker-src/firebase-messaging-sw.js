// firebase-messaging-sw.js — KaiNowPay
// Service Worker para Firebase Cloud Messaging (FCM) Push Notifications
// Este arquivo deve estar na raiz do domínio: /firebase-messaging-sw.js

importScripts("https://www.gstatic.com/firebasejs/11.9.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/11.9.0/firebase-messaging-compat.js");

// ──────────────────────────────────────────────────────────────────────
// ATENÇÃO: Mantenha este config sincronizado com o do app.html
// Substitua pelos valores do Firebase Console → Project Settings
// ──────────────────────────────────────────────────────────────────────
firebase.initializeApp({
  apiKey:            "AIzaSyDl1sR0sgb6BH52fwQ_twgSiwbGvrJ9Ek8",
  authDomain:        "kainowpay.firebaseapp.com",
  projectId:         "kainowpay",
  storageBucket:     "kainowpay.firebasestorage.app",
  messagingSenderId: "625304649401",
  appId:             "1:625304649401:web:0fb95cc8c350a528332568",
});

const messaging = firebase.messaging();

// ─── Notificações em Background ──────────────────────────────────────
// Quando o app está fechado/em background, o FCM aciona este handler
messaging.onBackgroundMessage((payload) => {
  console.log("[SW] FCM background message:", payload);

  const notificationTitle = payload.notification?.title || "KaiNowPay";
  const notificationOptions = {
    body:  payload.notification?.body  || "Você tem uma nova notificação",
    icon:  payload.notification?.icon  || "/favicon.svg",
    badge: "/favicon.svg",
    tag:   payload.data?.type || "knp-push",
    data:  payload.data || {},
    actions: [
      { action: "open",    title: "Abrir app" },
      { action: "dismiss", title: "Dispensar" },
    ],
    vibrate: [200, 100, 200],
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// ─── Clique na notificação ───────────────────────────────────────────
self.addEventListener("notificationclick", (event) => {
  event.notification.close();

  if (event.action === "dismiss") return;

  // Abre ou foca a janela do app
  const urlToOpen = event.notification.data?.url || "/";

  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then((windowClients) => {
      // Se já tem janela aberta, foca ela
      for (const client of windowClients) {
        if (client.url.includes(self.location.origin) && "focus" in client) {
          client.postMessage({ type: "FCM_NOTIFICATION_CLICK", data: event.notification.data });
          return client.focus();
        }
      }
      // Senão abre nova janela
      if (clients.openWindow) {
        return clients.openWindow(urlToOpen);
      }
    })
  );
});

// ─── Push direto (sem firebase SDK) ─────────────────────────────────
// Fallback para push via Web Push API diretamente
self.addEventListener("push", (event) => {
  if (!event.data) return;
  try {
    const data = event.data.json();
    // Se já foi tratado pelo Firebase SDK, ignorar
    if (data.from) return;

    const title = data.title || "KaiNowPay";
    const body  = data.body  || "Nova notificação";
    event.waitUntil(
      self.registration.showNotification(title, {
        body, icon: "/favicon.svg", badge: "/favicon.svg",
        tag: data.tag || "knp-push",
      })
    );
  } catch(e) {
    // payload não é JSON, ignorar
  }
});

console.log("[KaiNowPay SW] firebase-messaging-sw.js carregado ✅");
