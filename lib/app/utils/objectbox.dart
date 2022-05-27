import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../objectbox.g.dart';
import '../data/model.dart';

class ObjectBoxController extends GetxController {
  late final Box<Supplier> supplierBox;
  late final Box<SearchedSupplier> searchedSupplierBox;
  late final Box<PurchaseOrderItem> purchaseOrderItemBox;
  late final Box<PurchaseOrder> purchaseOrderBox;
  late final Box<SearchedPurchaseOrder> searchedPurchaseOrderBox;
  late final Box<ItemCategory> itemCategoryBox;
  late final Box<SearchedItemCategory> searchedItemCategoryBox;
  late final Box<Item> itemBox;
  late final Box<SearchedItem> searchedItemBox;
  late final Box<ItemVariant> itemVariantBox;
  late final Box<SearchedItemVariant> searchedItemVariantBox;
  late final Box<Company> companyBox;
  late final Box<SearchedCompany> searchedCompanyBox;
  late final Box<Unit> unitBox;
  late final Box<UnitRelation> unitRelationBox;
  late final Box<SearchedUnit> searchedUnitBox;
  late final Box<Customer> customerBox;
  late final Box<SearchedCustomer> searchedCustomerBox;
  late final Box<CustomerCategory> customerCategoryBox;
  late final Box<SearchedCustomerCategory> searchedCustomerCategoryBox;
  late final Box<ReceiptItem> receiptItemBox;
  late final Box<Receipt> receiptBox;
  late final Box<ReceiptInfo> receiptInfoBox;
  late final Box<SearchedReceipt> searchedReceiptBox;
  late final Box<Location> locationBox;
  late final Box<Pincode> pincodeBox;
  late final Box<StoreRoom> storeRoomBox;
  late final Box<SearchedStoreRoom> searchedStoreRoomBox;
  late final Box<Diary> diaryBox;
  late final Box<SearchedDiary> searchedDiaryBox;
  late final Box<PurchasedItem> purchasedItemBox;
  late final Box<SearchedPurchasedItem> searchedPurchasedItemBox;
  late final Box<Almirah> almirahBox;
  late final Box<SearchedAlmirah> searchedAlmirahBox;
  late final Box<Godown> godownBox;
  late final Box<SearchedGodown> searchedGodownBox;

  createBox(store) {
    supplierBox = Box<Supplier>(store);
    searchedSupplierBox = Box<SearchedSupplier>(store);
    purchaseOrderItemBox = Box<PurchaseOrderItem>(store);
    purchaseOrderBox = Box<PurchaseOrder>(store);
    searchedPurchaseOrderBox = Box<SearchedPurchaseOrder>(store);
    itemCategoryBox = Box<ItemCategory>(store);
    searchedItemCategoryBox = Box<SearchedItemCategory>(store);
    itemBox = Box<Item>(store);
    searchedItemBox = Box<SearchedItem>(store);
    itemVariantBox = Box<ItemVariant>(store);
    searchedItemVariantBox = Box<SearchedItemVariant>(store);
    companyBox = Box<Company>(store);
    searchedCompanyBox = Box<SearchedCompany>(store);
    unitBox = Box<Unit>(store);
    unitRelationBox = Box<UnitRelation>(store);
    searchedUnitBox = Box<SearchedUnit>(store);
    customerBox = Box<Customer>(store);
    searchedCustomerBox = Box<SearchedCustomer>(store);
    customerCategoryBox = Box<CustomerCategory>(store);
    searchedCustomerCategoryBox = Box<SearchedCustomerCategory>(store);
    receiptItemBox = Box<ReceiptItem>(store);
    receiptBox = Box<Receipt>(store);
    receiptInfoBox = Box<ReceiptInfo>(store);
    searchedReceiptBox = Box<SearchedReceipt>(store);
    locationBox = Box<Location>(store);
    pincodeBox = Box<Pincode>(store);
    storeRoomBox = Box<StoreRoom>(store);
    searchedStoreRoomBox = Box<SearchedStoreRoom>(store);
    diaryBox = Box<Diary>(store);
    searchedDiaryBox = Box<SearchedDiary>(store);
    purchasedItemBox = Box<PurchasedItem>(store);
    searchedPurchasedItemBox = Box<SearchedPurchasedItem>(store);
    almirahBox = Box<Almirah>(store);
    searchedAlmirahBox = Box<SearchedAlmirah>(store);
    godownBox = Box<Godown>(store);
    searchedGodownBox = Box<SearchedGodown>(store);
  }

  Future<void> create() async {
    final store = await openStore();
    createBox(store);
  }
}
