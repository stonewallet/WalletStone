import 'package:walletstone/API/createWallet/createnewwallet.dart';

const baseUrl = "https://54.234.68.88";

const travelListUrl = "$baseUrl/travel/list/";
const travelPostListUrl = "$baseUrl/travel/list/";
const travelList2Url = "$baseUrl/travel/list";
const travelLoginUrl = "$baseUrl/travel/login/";
const travelRegisterUrl = "$baseUrl/travel/register/";
const getWalletUrl = "$baseUrl/travel/get/wallet/";
const addUserUrl = "$baseUrl/travel/add/user/trip/";
const portfolio = "$baseUrl/travel/add/coins/";
const addPostAssets = "$baseUrl/travel/add/coins/";
const updatePortfolio = "$baseUrl/travel/update/portfolio/";
const createPortfolio = "$baseUrl/travel/add/portfolio/";
const deletePortfolio = "$baseUrl/travel/delete/portfolio/";
const searchPortfolio = "$baseUrl/travel/portfolio/dropdown/";
const getPdf = "$baseUrl/travel/export/trip/pdf/";
const createwallet = "$baseUrl/travel/add/wallet/";
const dropdownasset = "$baseUrl/travel/get/prices/";
const logOutPost = "$baseUrl/travel/logout/";
const keyUrl = "$baseUrl/travel/get/wallet/keys/";
const endTripUrl = "$baseUrl/travel/trip/end/";
const resumeTripUrl = "$baseUrl/travel/trip/resume/";
const iniviteGetUser = "$baseUrl/travel/get/user/";
const createNotification = "$baseUrl/travel/create/notification/";
const getNotification = "$baseUrl/travel/list/notification/";
const readNotification = "$baseUrl/travel/read/notification/";
const deleteNotification = "$baseUrl/travel/notification/";
const getNotificationCount = "$baseUrl/travel/unread/count/notification/";
const getSettingWallet = "$baseUrl/travel/all/wallet/";
const sendWallet = "$baseUrl/travel/send/monero/";
const getseedkey = "$baseUrl/travel/get/keys/";
const adddContact = "$baseUrl/travel/contacts/";
const changeUserPassword = "$baseUrl/travel/change/password/";
const create2Factor = "$baseUrl/travel/totp/create/";
const authEnable = "$baseUrl/travel/enable/twofa/";
const authDisable = "$baseUrl/travel/disable/twofa/";
const checkAuthStatusValue = "$baseUrl/travel/check/twofa/";
const sendOTPLogin = "$baseUrl/travel/totp/login";
const deleteAuth = "$baseUrl/travel/delete/totp/device/";

late WalletResponse walletResponse;
late String tripId;
