import 'package:objectbox/objectbox.dart';

@Entity()
class Godown {
  int? id;
  @Unique(onConflict: ConflictStrategy.replace)
  String? name;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink("godown")
  final items = ToMany<StoredAtGodown>();
  @Backlink("godown")
  final storeRooms = ToMany<StoreRoom>();
  @Backlink("godown")
  final almirahs = ToMany<Almirah>();
  @Backlink('searchedGodown')
  final searches = ToMany<SearchedGodown>();
}

@Entity()
class SearchedGodown {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedGodown = ToOne<Godown>();
}

@Entity()
class Almirah {
  int? id;
  @Unique(onConflict: ConflictStrategy.replace)
  String? name;
  int? row;
  int? column;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink("almirah")
  final items = ToMany<StoredAtAlmirah>();
  final godown = ToOne<Godown>();
  final room = ToOne<StoreRoom>();
  @Backlink('searchedAlmirah')
  final searches = ToMany<SearchedAlmirah>();
}

@Entity()
class SearchedAlmirah {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedAlmirah = ToOne<Almirah>();
}

@Entity()
class Diary {
  int? id;
  @Unique(onConflict: ConflictStrategy.replace)
  String? title;
  String? content;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink('searchedDiary')
  final searches = ToMany<SearchedDiary>();
}

@Entity()
class SearchedDiary {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedDiary = ToOne<Diary>();
}

@Entity()
class StoreRoom {
  int? id;
  @Unique(onConflict: ConflictStrategy.replace)
  String? name;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink("storeRoom")
  final items = ToMany<StoredAtStoreRoom>();
  final godown = ToOne<Godown>();
  @Backlink('searchedStoreRoom')
  final searches = ToMany<SearchedStoreRoom>();
  @Backlink("room")
  final almirahs = ToMany<Almirah>();
}

@Entity()
class SearchedStoreRoom {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedStoreRoom = ToOne<StoreRoom>();
}

@Entity()
class Pincode {
  int? id;
  @Unique(onConflict: ConflictStrategy.replace)
  String? pincode;
  String? district;
  String? state;
  String? country;
  @Backlink("pin")
  final locations = ToMany<Location>();
}

@Entity()
class Location {
  int? id;
  String? area;
  String? village;
  String? panchayat;
  String? block;
  final pin = ToOne<Pincode>();
}

@Entity()
class Supplier {
  int? id;
  @Unique()
  String? phone;
  List<String>? otherPhone;
  String? contactListId;
  String? nickName;
  String? shopOrBusinessName;
  @Index(type: IndexType.value)
  String? name;
  String? address;
  List<String>? account;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink("suppliedBy")
  final suppliedItems = ToMany<PurchasedItem>();
  final location = ToOne<Location>();
  @Backlink('searchedSupplier')
  final searches = ToMany<SearchedSupplier>();
}

@Entity()
class SearchedSupplier {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedSupplier = ToOne<Supplier>();
}

@Entity()
class PurchaseOrderItem {
  int? id;
  double? quantity;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  final unit = ToOne<Unit>();
  final item = ToOne<ItemVariant>();
  final orderedIn = ToOne<PurchaseOrder>();
}

@Entity()
class PurchaseOrder {
  int? id;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  final orderedItems = ToMany<PurchaseOrderItem>();
  final supplier = ToOne<Supplier>();
}

@Entity()
class SearchedPurchaseOrder {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedOrder = ToOne<PurchaseOrder>();
}

@Entity()
class ItemCategory {
  int? id;
  @Unique()
  String? name;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink('searchedCategory')
  final searches = ToMany<SearchedItemCategory>();
  @Backlink('category')
  final items = ToMany<Item>();
}

@Entity()
class SearchedItemCategory {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedCategory = ToOne<ItemCategory>();
}

@Entity()
class Item {
  int? id;
  @Unique()
  String? name;
  List<String>? alternateName;
  String? description;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink("item")
  final variant = ToMany<ItemVariant>();
  final company = ToOne<Company>();
  final category = ToOne<ItemCategory>();
}

@Entity()
class SearchedItem {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedItem = ToOne<Item>();
}

@Entity()
class ItemVariant {
  int? id;
  String? size;
  String? color;
  String? model;
  double? minimumStock;
  String? description;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  final orderedAs = ToMany<PurchaseOrderItem>();
  final item = ToOne<Item>();
  @Backlink("purchasedItem")
  final purchasedRecord = ToMany<PurchasedItem>();
  @Backlink('searchedItem')
  final searches = ToMany<SearchedItem>();
  final minimumStockUnit = ToOne<Unit>();
}

@Entity()
class SearchedItemVariant {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedItemVariant = ToOne<ItemVariant>();
}

@Entity()
class PurchasedItem {
  int? id;
  @Property(type: PropertyType.date)
  DateTime? purchasedDate;
  @Property(type: PropertyType.date)
  DateTime? dateOfExpiry;
  double? purchasingPrice;
  double? purchasedQuantity;
  double? currentQuantity;
  double? sellingPrice;
  int? row;
  int? column;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  final sellingPriceUnit = ToOne<Unit>();
  final purchasingPriceUnit = ToOne<Unit>();
  final purchasedQuantityUnit = ToOne<Unit>();
  final currentQuantityUnit = ToOne<Unit>();
  final purchasedItem = ToOne<ItemVariant>();
  final suppliedBy = ToOne<Supplier>();
  final storedAtAlmirah = ToMany<StoredAtAlmirah>();
  final storedAtStoreRoom = ToMany<StoredAtStoreRoom>();
  final storedAtGodown = ToMany<StoredAtGodown>();
  @Backlink('searchedPurchasedItem')
  final searches = ToMany<SearchedPurchasedItem>();
}

@Entity()
class StoredAtAlmirah {
  int? id;
  double? quantity;
  final almirah = ToOne<Almirah>();
}

@Entity()
class StoredAtStoreRoom {
  int? id;
  double? quantity;
  final storeRoom = ToOne<StoreRoom>();
}

@Entity()
class StoredAtGodown {
  int? id;
  double? quantity;
  final godown = ToOne<Godown>();
}

@Entity()
class SearchedPurchasedItem {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedPurchasedItem = ToOne<PurchasedItem>();
}

@Entity()
class Company {
  int? id;
  String? name;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink('searchedCompany')
  final searches = ToMany<SearchedCompany>();
  @Backlink('company')
  final items = ToMany<Item>();
}

@Entity()
class SearchedCompany {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedCompany = ToOne<Company>();
}

@Entity()
class Unit {
  int? id;
  @Unique()
  String? fullName;
  String? shortName;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink('searchedUnit')
  final searches = ToMany<SearchedUnit>();
}

@Entity()
class UnitRelation {
  int? id;
  double? value;
  final unitFrom = ToOne<Unit>();
  final unitTo = ToOne<Unit>();
}

@Entity()
class SearchedUnit {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedUnit = ToOne<Unit>();
}

@Entity()
class Customer {
  int? id;
  @Unique()
  String? phone;
  List<String>? otherPhone;
  String? contactListId;
  String? nickName;
  @Index(type: IndexType.value)
  String? name;
  String? gender;
  String? address;
  List<String>? account;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink("customer")
  final receipts = ToMany<Receipt>();
  final location = ToOne<Location>();
  @Backlink('searchedCustomer')
  final searches = ToMany<SearchedCustomer>();
  final category = ToOne<CustomerCategory>();
}

@Entity()
class SearchedCustomer {
  int id;
  SearchedCustomer({
    this.id = 0,
  });
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedCustomer = ToOne<Customer>();
}

@Entity()
class CustomerCategory {
  int? id;
  @Unique()
  String? name;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  @Property(type: PropertyType.date)
  DateTime? dateOfUpdation;
  @Backlink('searchedCategory')
  final searches = ToMany<SearchedCustomerCategory>();
  @Backlink('category')
  final customers = ToMany<Customer>();
}

@Entity()
class SearchedCustomerCategory {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedCategory = ToOne<CustomerCategory>();
}

@Entity()
class ReceiptItem {
  int? id;
  double? quantity;
  double? soldPrice;
  final unit = ToOne<Unit>();
  final item = ToOne<PurchasedItem>();
}

@Entity()
class Receipt {
  int? id;
  final receiptInfo = ToOne<ReceiptInfo>();
  final receiptItems = ToMany<ReceiptItem>();
  final customer = ToOne<Customer>();
}

@Entity()
class ReceiptInfo {
  int? id;
  String? description;
  @Property(type: PropertyType.date)
  DateTime dateOfCreation = DateTime.now();
  String? number;
  double? due;
  @Property(type: PropertyType.date)
  DateTime? dueDate;
  double? totalDiscount;
}

@Entity()
class SearchedReceipt {
  int? id;
  @Property(type: PropertyType.date)
  DateTime datetime = DateTime.now();
  final searchedReceipt = ToOne<Receipt>();
}
