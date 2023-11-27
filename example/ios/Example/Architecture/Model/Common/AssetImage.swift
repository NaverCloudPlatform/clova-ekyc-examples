/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

enum AssetImage: String {
    // tilted card frame
    case angle_75_green
    case angle_75_red
    case angle_75_white_left
    case angle_75_white_right
    case angle_75_white
    case angle_80_green
    case angle_80_red
    case angle_80_white_left
    case angle_80_white_right
    case angle_80_white
    case angle_85_green
    case angle_85_red
    case angle_85_white_left
    case angle_85_white_right
    case angle_85_white
    case angle_90_green
    case angle_90_red
    case angle_90_white_back
    case angle_90_white_left
    case angle_90_white_right
    case angle_90_white_vertical
    case angle_90_white
    case angle_95_green
    case angle_95_red
    case angle_95_white_left
    case angle_95_white_right
    case angle_95_white
    case angle_100_green
    case angle_100_red
    case angle_100_white_left
    case angle_100_white_right
    case angle_100_white
    case angle_105_green
    case angle_105_red
    case angle_105_white_left
    case angle_105_white_right
    case angle_105_white

    // face guide
    case guide_top_left
    case guide_top_right
    case guide_bottom_left
    case guide_bottom_right

    // icon
    case icon_back
    case icon_camera_green
    case icon_camera_round
    case icon_camera
    case icon_close
    case icon_compare
    case icon_confirm
    case icon_edit
    case icon_failed
    case icon_gallery
    case icon_next
    case icon_reverse
    case icon_retry
    case icon_rotate
    case icon_setting
    case icon_success
    case icon_warning

    // etc.
    case ncp_title
    case double_check_face
    case double_check_card_front
    case double_check_card_tilt
    case double_check_card_back

    var uiImage: UIImage? {
        return UIImage(named: rawValue)
    }
}
