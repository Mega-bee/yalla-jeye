class ApiLink {
  static String host = 'https://yallajeyiapi.azurewebsites.net/api/';
  static String deviceToken ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InBhdG91cmFib3VscGV0ZTFAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6InBhdG91cmFib3VscGV0ZTFAZ21haWwuY29tIiwiVUlEIjoiYjFmM2QyY2EtMGM3Zi00YWE0LTg3MzEtN2Q2NDEwZWUwNTlkIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiYjFmM2QyY2EtMGM3Zi00YWE0LTg3MzEtN2Q2NDEwZWUwNTlkIiwibmJmIjoxNjQ1OTUwNDAxLCJleHAiOjE2Nzc0ODY0MDEsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjQ0MzEwIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMTAifQ.yz7gDbdaiKOzfsRRfh3F3jzSpYOJpu3zVkCKVm52EWc";
  static String myAddressesSettings = host + 'addresses/GetAllAddresses';
  static String HomePage = host + "HomePage/GetHomePage";
  static String CreateAdress = host + 'addresses/CreateAddress';
  static String updateAddress = host + 'addresses/UpdateAddress';
  static String login = host + 'Accounts/EmailSignIn';
  static String Register = host + 'Accounts/EmailSignUp/1';
  static String CompleteProfile = host + 'Accounts/CompleteProfile';
  static String getAllCities = host + 'addresses/GetAllRegions';
  static String DeleteAddress=host+"addresses/DeleteAddress";
  static String getAllAddresses=host+"addresses/GetAllAddresses";
  static String placeOrder=host+"orders/placeorder";
  static String ForgetPassword=host+"Accounts/ForgetPassword";
  static String ResetPassword=host+"Accounts/ResetPassword";
  static String GetUserProfile=host+"Accounts/GetUserProfile";
  static String UpdateProfile=host+"Accounts/UpdateProfile";
  static String GetAllOrders=host+"orders/GetUserOrders";
  static String GetOrderById=host+"orders/GetUserOrder";
  static String SetOrderStatus=host+"orders/SetOrderStatus";
  static String ConfirmEmail=host+"Accounts/ConfirmEmail";
  static String redeemCode=host+"orders/RedeemPromoCode";
  static String getCancelOrderReason=host+"Orders/GetCancelStatuses";
  static String cancelOrder=host+"Orders/CancelOrder";
  static String rateOrder=host+"orders/SetOrderRating";
  static String generateOtp=host+"Accounts/GenerateOtp";
  static String confirmOtp=host+"Accounts/ConfirmOtp";
  static String confirmAccountOtp=host+"Accounts/ConfirmAccount";
  static String resendOtp=host+"Accounts/ResendOtp";
  static String Notification=host+"Notifications/GetAllNotifications";

  static String getDriverOrders=host+"Driver/GetDriverOrders";
  static String getDriverOrderDetails=host+"Driver/GetDriverOrder";
  static String setToggleActivity=host+"Driver/ToggleActivity";
  static String setDriverOrderStatus=host+"Driver/SetOrderStatus";
  static String markItemAsDone=host+"Driver/MarkItemAsDone";
}
