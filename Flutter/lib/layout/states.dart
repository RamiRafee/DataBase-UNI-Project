

abstract class ShopStates{}
class ShopInitialState extends ShopStates {}

/// Bottom Nav States

class ShopChangeBottomNavState extends ShopStates{}
class ShopChangeDrawerLState extends ShopStates{}
class ShopChangeDrawerState extends ShopStates{}
/// Home States

class ShopLoadingHomeDataStates extends ShopStates{}

class ShopSuccessHomeDataStates extends ShopStates{}

class ShopErrorHomeDataStates extends ShopStates{}

/// Fraud data States

class ShopLoadingFraudStates extends ShopStates{}

class ShopSuccessFraudStates extends ShopStates{}

class ShopErrorFraudStates extends ShopStates{}

/// Home States

class ShopLoadingProductDataStates extends ShopStates{}

class ShopSuccessProductDataStates extends ShopStates{}

class ShopErrorProductDataStates extends ShopStates{}

/// Categories States

class ShopSuccessCategoriesStates extends ShopStates{}

class ShopErrorCategoriesStates extends ShopStates{}


/// add product States

class ShopLoadingAddProductStates extends ShopStates{}

class ShopSuccessAddProductStates extends ShopStates{}

class ShopErrorAddProductStates extends ShopStates{}


class ShopContinueState extends ShopStates{}

class ShopCancelState extends ShopStates{}

class ShopChangeStepState extends ShopStates{}

///  Search brand States

class SearchBrandLoadingState extends ShopStates{}

class SearchBrandSuccessState extends ShopStates{}

class SearchBrandErrorState extends ShopStates{}

///  get brand States

class GetBrandLoadingState extends ShopStates{}

class GetBrandSuccessState extends ShopStates{}

class GetBrandErrorState extends ShopStates{}

/// get product of brands States

class ShopLoadingProductBrandsStates extends ShopStates{}

class ShopSuccessProductBrandsStates extends ShopStates{}

class ShopErrorProductBrandsStates extends ShopStates{}


class ShopAddToChartState extends ShopStates{}
class ShopRemoveFromChartState extends ShopStates{}

/// transaction States

class ShopLoadingTransactionStates extends ShopStates{}

class ShopSuccessTransactionStates extends ShopStates{}

class ShopErrorTransactionStates extends ShopStates{}




/// search
class SearchInitialState extends ShopStates{}

class SearchLoadingState extends ShopStates{}

class SearchSuccessState extends ShopStates{}

class SearchErrorState extends ShopStates{}


/// default user by admin

class ShopLoadingDefaultUserStates extends ShopStates{}

class ShopSuccessDefaultUserStates extends ShopStates{}

class ShopErrorDefaultUserStates extends ShopStates{}

/// admin bot detection

class ShopLoadingDetectionStates extends ShopStates{}

class ShopSuccessDetectionStates extends ShopStates{}

class ShopErrorDetectionStates extends ShopStates{}

/// admin search user

class ShopLoadingUserSearchStates extends ShopStates{}

class ShopSuccessUserSearchStates extends ShopStates{}

class ShopErrorUserSearchStates extends ShopStates{}

/// Power Bi

class ShopLoadingPowerBIStates extends ShopStates{}

class ShopSuccessPowerBIStates extends ShopStates{}

class ShopErrorPowerBIStates extends ShopStates{}