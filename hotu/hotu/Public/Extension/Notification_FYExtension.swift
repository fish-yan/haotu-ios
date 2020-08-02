//
//  Notification_FYExtension.swift
//  hotu
//
//  Created by 薛焱 on 2019/12/4.
//  Copyright © 2019 薛焱. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let HTRoleChanged = Notification.Name("HTRoleChanged")
    public static let HTVideoChanged = Notification.Name("HTVideoChanged")
    public static let HTActivityChanged = Notification.Name("HTActivityChanged")
    public static let HTMatchChanged = Notification.Name("HTMatchChanged")
    public static let HTProductChanged = Notification.Name("HTProductChanged")
    public static let HTCourseChanged = Notification.Name("HTCourseChanged")
    public static let HTLiveChanged = Notification.Name("HTLiveChanged")
    public static let HTFavChanged = Notification.Name("HTFavChanged")
    public static let HTCommentChanged = Notification.Name("HTCommentChanged")
    public static let HTBadgeChanged = Notification.Name("HTBadgeChanged")
    public static let HTUserInfoChanged = Notification.Name("HTUserInfoChanged")
    public static let HTReceivedMsg = Notification.Name("HTReceivedMsg")
}

struct HTNotificationKey {
    static let role = "HTNotificationKeyRoleKey"
    static let badge = "HTNotificationKeyBadgeKey"
}
