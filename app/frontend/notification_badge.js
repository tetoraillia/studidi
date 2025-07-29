import { createConsumer } from "@rails/actioncable";
const consumer = createConsumer();

async function updateBadge() {
  const badge = document.getElementById("notification-badge");
  if (!badge) return;
  try {
    const resp = await fetch("/notifications/unread_count.json", { credentials: "same-origin" });
    const data = await resp.json();
    if (data.unread > 0) {
      badge.classList.remove("d-none");
      badge.classList.add("d-inline");
    } else {
      badge.classList.add("d-none");
      badge.classList.remove("d-inline");
    }
  } catch (e) {
    // fail silently
  }
}

export default function setupNotificationBadge(userId) {
  if (!userId) return;
  updateBadge();
  consumer.subscriptions.create(
    { channel: "NotificationsChannel" },
    {
      received() {
        updateBadge();
      },
    }
  );
}

window.setupNotificationBadge = setupNotificationBadge;
