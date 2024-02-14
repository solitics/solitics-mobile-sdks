package com.solitics.integration.app.messaging

import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.INotificationServiceExtension
import com.solitics.integration.app.domain.utils.log

class OneSignalNotificationService : INotificationServiceExtension {
    override fun onNotificationReceived(event: INotificationReceivedEvent) {
        log("OneSignalNotificationService", "OneSignalNotificationService ${event.notification.additionalData}")
    }
}