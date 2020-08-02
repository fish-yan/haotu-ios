
//#if DEBUG
/// 融云key
//let RONG_CLOUD_KEY = "mgb7ka1nmdftg"
///// 基础连接
////let API = "http://101.44.2.178:1234/api/v1.0/"
//let API = "http://local.hotu.club:1234/api/v1.0/"
//#else
/// 融云key
let RONG_CLOUD_KEY = "8w7jv4qb83ahy"
/// 基础连接
let API = "http://www.hotu.club:9595/api/v1.0/"
//#endif

// MARK: - H5
/// 免责条款
let HTML_MIANZE = "http://www.hotu.club:9595/agreement/liability.html"
/// 用户协议
let HTML_USER_PRO = "http://www.hotu.club:9595/agreement/agreementhz.html"
/// 隐私政策
let HTML_PRIVATE = "http://www.hotu.club:9595/agreement/agreement.html"

// MARK: - public
/// 检查更新
let CHECK_UPDATE = API + "version/selectNewVersionUrl"
/// 上传图片
let UPLOAD_IMAGE = API + "file/uploadSingle"
/// 发送验证码
let SEND_MSG_CODE = API + "user/sendValidCode"
/// 数据字典
let DICT_BY_KEY = API + "dic/getDicItemByKey"
/// 广告字典
let AD_BY_KEY = API + "dic/getAdvertisementCovers"
/// 视频分享
let GET_SHARE_URL = API + "topic/share/video/"
/// 商家分享
let GET_MERC_SHARE_URL = API + "topic/share/company/"
/// 直播分享
let GET_LIVE_SHARE_URL = API + "topic/share/liveBroadcast"
/// 分享二维码
let GET_SHARE_QRCODE = API + "topic/share/liveBroadcastQrCode"
/// 登录
let LOGIN = API + "user/AppFastlogin"
/// 是否已绑定微信登录
let IS_BIND_WX = API + "user/isBindOpenId"
/// 微信登录更新用户信息
let THRID_UPDATE_USER_INFO = API + "user/thirdPartyRegister"

// MARK: - 首页
/// 首页视频列表
let VIDEO_LIST = API + "topic/video/listVideo"
/// 视频详情
let VIDEO_DETAIL = API + "topic/video/videodetail/"
/// 首页活动列表
let ACTIVITY_LIST = API + "activity/queryActivityList"
/// 活动详情
let ACTIVITY_DETAIL = API + "activity/getActivityDetail"
/// 获取报名详情
let ACTIVITY_PAY_INFO = API + "singup/getSignUpActivityDetail"
/// 评论列表
let COMMENT_LIST = API + "topic/video/comment/listComment"
/// 评论
let ADD_COMMENT = API + "topic/video/comment/addComment"
/// 删除评论
let DELETE_COMMENT = API + "topic/video/comment/delComment"
/// 点赞
let FAV_ACTION = API + "topic/video/likeorstore/addLikeOrStore"
/// 取消点赞
let UNFAV_ACTION = API + "topic/video/likeorstore/delLikeOrStore"
/// 更新分享次数
let UPDATE_SHARE_COUNT = API + "topic/video/updateForwardCount"
/// 更新播放次数
let UPDATE_PLAY_COUNT = API + "topic/video/updateSeeCount"
/// @我，评论，点赞
let MSG_COMMENT_LIST = API + "im/user/notify/listByUserIdAndType"
/// 升级赛事
let UPDATE_MATCH = API + "activity/upgradeToMatchApply"

/// 大家在搜
let SEAARCH_HOT_KEY = API + "searchKeyword/list"
/// 增加搜索关键字
let ADD_SEARCH_KEY = API + "searchKeyword/insertOrUpdate"
/// 搜索商品
let PRODUCT_LIST = API + "commodity/listByPattern"


// MARK: - 发布
/// 发布视频
let PUBLISH_VIDEO = API + "topic/video/addVideo"
/// 发布视频
let PUBLISH_VIDEO2 = API + "topic/video/addVideoVersion2"
/// 视频签名
let PUBLISH_VIDEO_SIGN = API + "sign/video/generator"
/// 发布活动
let PUBLISH_ACTIVITY = API + "activity/releaseActivity"
/// 发布赛事
let PUBLISH_MATCH = API + "activity/releaseMatch"
/// 发布课程
let PUBLISH_COURSE = API + "commodity/publish"
/// 报名活动
let SIGN_UP_ACTIVITY = API + "singup/signUpActivity1"
/// 我的好友
let MY_FRIEND = API + "user/listFollowUser"
/// 话题
let TOPIC_LIST = API + "topic/image/listImage"
/// 新增话题
let ADD_TOPIC = API + "topic/image/addImage"
/// 关联活动
let ASSO_ACTIVITY = API + "activity/listLinkedActivitys"
/// 查询关联的商户、教练、俱乐部
let ASSO_MCC = API + "group/listLinkedGroups"
/// 查询可直播列表
let ANCHOR_LIST = API + "user/listArchorList"

// MARK: - 我的
/// 获取用户信息
let USER_INFO = API + "user/queryUserInfoByUserId"
/// 修改用户资料
let EDIT_USER_INFO = API + "user/editUserInfo"
/// 获取账户余额
let GET_BALANCE = API + "user/account/"
/// 提现
let CASH_ACTION = API + "user/account/"
/// 添加银行卡
let ADD_BANK = API + "user/addUserBankCard"
/// 银行卡列表
let BANK_LIST = API + "user/queryUserBankList"
/// 账单（群主）
let BILL_MANAGER = API + "userGroupAccount/getGroupAcountDetail"
/// 账单（普通）
let BILL_CUSTOMER = API + "user/queryUserAccountdetail"

/// 申请为群主
let APPLY_CLUB = API + "group/groupApply"
/// 申请为商家
let APPLY_MERC = API + "business/businessApply"
/// 申请为教练
let APPLY_COACH = API + "coach/coachApply"
/// 申请为主播
let APPLY_ANCHOR = API + "group/archorApply"

/// 我的群
let MY_CLUB = API + "group/queryMyGroup"
/// 群详情
 let CLUB_DETAIL = API + "group/viewGroupById"
/// 群成员
let CLUB_MEMBER_LIST = API + "userGroupAccount/findAllMember"
/// 关注用户
let ATTENTION_USER = API + "user/followUser"
/// 取消关注
let CANCEL_ATTENTION = API + "user/cancelFollowUser"
/// 退出群
let EXIT_CLUB = API + "group/quitGroup"
/// 加入群
let JOIN_CLUB = API + "group/joinGroup"
/// 更新群信息
let UPDATE_CLUB_INFO = API + "group/editGroupInfo"

/// 我的活动
let MY_ACTIVITY = API + "activity/queryMyCreateActivity"
/// 我报名的活动
let MY_SING_ACTIVITY = API + "activity/queryMyActivityList"
/// 我的商品
let MY_PRODUCT = API + "commodity/listByUserAndType"
/// 商品详情
let PRODUCT_DETAIL = API + "commodity/getById"
/// 我的视频
let MY_VIDEO_LIST = API + "topic/video/listMyPublishVideo"
/// 我点赞的视频
let MY_FAV_VIDEO_LIST = API + "topic/video/listMyLikedVideo"
/// 我的直播
let MY_LIVE_LIST = API + "broadcast/list"
/// 直播详情
let MY_LIVE_DETAIL = API + "broadcast/listImages"
/// 获取直播的主播
let LIVE_ANCHOR = API + "broadcast/listArchorsByActivityId"
/// 添加主播
let ADD_ANCHOR = API + "broadcast/addArchor"
/// 更新直播查看次数
let UPDATE_LIVE_SEE_COUNT = API + "broadcast/addSeeCount"
/// 直播图片点赞
let LIVE_IMG_FAV = API + "broadcast/addLikeCount"
/// 直播图片删除
let LIVE_IMG_DELETE = API + "broadcast/delete"

/// 我的保单
let MY_POLICY_LIST = API + "singup/getSafeList"

/// 是否允许访问通讯录
let GET_VISIT_CONTACT = API + "userSetUp/getUserSetUp"
/// 设置是否允许访问通讯录
let SET_VISIT_CONTACT = API + "userSetUp/updateByUserId"
/// 实名认证
let USER_VERIFITY = API + "user/savedIdNo"
/// 投诉
let USER_REPORT = API + "complain/addComplain"


