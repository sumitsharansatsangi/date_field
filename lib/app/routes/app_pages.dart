import 'package:get/get.dart';

import '../modules/almirah/bindings/almirah_binding.dart';
import '../modules/almirah/create_almirah/bindings/create_almirah_binding.dart';
import '../modules/almirah/create_almirah/views/create_almirah_view.dart';
import '../modules/almirah/list_almirah/bindings/list_almirah_binding.dart';
import '../modules/almirah/list_almirah/views/list_almirah_view.dart';
import '../modules/almirah/views/almirah_view.dart';
import '../modules/company/bindings/company_binding.dart';
import '../modules/company/create_company/bindings/create_company_binding.dart';
import '../modules/company/create_company/views/create_company_view.dart';
import '../modules/company/list_company/bindings/list_company_binding.dart';
import '../modules/company/list_company/views/list_company_view.dart';
import '../modules/company/views/company_view.dart';
import '../modules/customer/bindings/customer_binding.dart';
import '../modules/customer/create_customer/bindings/create_customer_binding.dart';
import '../modules/customer/create_customer/views/create_customer_view.dart';
import '../modules/customer/list_customer/bindings/list_customer_binding.dart';
import '../modules/customer/list_customer/views/list_customer_view.dart';
import '../modules/customer/views/customer_view.dart';
import '../modules/customer_category/bindings/customer_category_binding.dart';
import '../modules/customer_category/create_customer_category/bindings/create_customer_category_binding.dart';
import '../modules/customer_category/create_customer_category/views/create_customer_category_view.dart';
import '../modules/customer_category/list_customer_category/bindings/list_customer_category_binding.dart';
import '../modules/customer_category/list_customer_category/views/list_customer_category_view.dart';
import '../modules/customer_category/views/customer_category_view.dart';
import '../modules/diary/bindings/diary_binding.dart';
import '../modules/diary/create_diary/bindings/create_diary_binding.dart';
import '../modules/diary/create_diary/views/create_diary_view.dart';
import '../modules/diary/views/diary_view.dart';
import '../modules/godown/bindings/godown_binding.dart';
import '../modules/godown/create_godown/bindings/create_godown_binding.dart';
import '../modules/godown/create_godown/views/create_godown_view.dart';
import '../modules/godown/list_godown/bindings/list_godown_binding.dart';
import '../modules/godown/list_godown/views/list_godown_view.dart';
import '../modules/godown/views/godown_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/item/bindings/item_binding.dart';
import '../modules/item/create_item/bindings/create_item_binding.dart';
import '../modules/item/create_item/views/create_item_view.dart';
import '../modules/item/list_item/bindings/list_item_binding.dart';
import '../modules/item/list_item/views/list_item_view.dart';
import '../modules/item/views/item_view.dart';
import '../modules/item_category/bindings/item_category_binding.dart';
import '../modules/item_category/create_item_category/bindings/create_item_category_binding.dart';
import '../modules/item_category/create_item_category/views/create_item_category_view.dart';
import '../modules/item_category/list_item_category/bindings/list_item_category_binding.dart';
import '../modules/item_category/list_item_category/views/list_item_category_view.dart';
import '../modules/item_category/views/item_category_view.dart';
import '../modules/item_variant/bindings/item_variant_binding.dart';
import '../modules/item_variant/create_item_variant/bindings/create_item_variant_binding.dart';
import '../modules/item_variant/create_item_variant/views/create_item_variant_view.dart';
import '../modules/item_variant/list_item_variant/bindings/list_item_variant_binding.dart';
import '../modules/item_variant/list_item_variant/views/list_item_variant_view.dart';
import '../modules/item_variant/views/item_variant_view.dart';
import '../modules/pdf/bindings/pdf_binding.dart';
import '../modules/pdf/views/pdf_view.dart';
import '../modules/purchase_order/bindings/purchase_order_binding.dart';
import '../modules/purchase_order/create_purchase_order/bindings/create_purchase_order_binding.dart';
import '../modules/purchase_order/create_purchase_order/views/create_purchase_order_view.dart';
import '../modules/purchase_order/list_purchase_order/bindings/list_purchase_order_binding.dart';
import '../modules/purchase_order/list_purchase_order/views/list_purchase_order_view.dart';
import '../modules/purchase_order/views/purchase_order_view.dart';
import '../modules/purchased_item/bindings/purchased_item_binding.dart';
import '../modules/purchased_item/create_purchased_item/bindings/create_purchased_item_binding.dart';
import '../modules/purchased_item/create_purchased_item/views/create_purchased_item_view.dart';
import '../modules/purchased_item/list_purchased_item/bindings/list_purchased_item_binding.dart';
import '../modules/purchased_item/list_purchased_item/views/list_purchased_item_view.dart';
import '../modules/purchased_item/views/purchased_item_view.dart';
import '../modules/receipt/bindings/receipt_binding.dart';
import '../modules/receipt/update_receipt/bindings/update_receipt_binding.dart';
import '../modules/receipt/update_receipt/views/update_receipt_view.dart';
import '../modules/receipt/views/receipt_view.dart';
import '../modules/sales_order/bindings/sales_order_binding.dart';
import '../modules/sales_order/views/sales_order_view.dart';
import '../modules/store_room/bindings/store_room_binding.dart';
import '../modules/store_room/create_store_room/bindings/create_store_room_binding.dart';
import '../modules/store_room/create_store_room/views/create_store_room_view.dart';
import '../modules/store_room/list_store_room/bindings/list_store_room_binding.dart';
import '../modules/store_room/list_store_room/views/list_store_room_view.dart';
import '../modules/store_room/views/store_room_view.dart';
import '../modules/supplier/bindings/supplier_binding.dart';
import '../modules/supplier/create_supplier/bindings/create_supplier_binding.dart';
import '../modules/supplier/create_supplier/views/create_supplier_view.dart';
import '../modules/supplier/list_supplier/bindings/list_supplier_binding.dart';
import '../modules/supplier/list_supplier/views/list_supplier_view.dart';
import '../modules/supplier/views/supplier_view.dart';
import '../modules/unit/bindings/unit_binding.dart';
import '../modules/unit/create_unit/bindings/create_unit_binding.dart';
import '../modules/unit/create_unit/views/create_unit_view.dart';
import '../modules/unit/list_unit/bindings/list_unit_binding.dart';
import '../modules/unit/list_unit/views/list_unit_view.dart';
import '../modules/unit/views/unit_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ITEM,
      page: () => ItemView(),
      binding: ItemBinding(),
      children: [
        GetPage(
          name: _Paths.LIST_ITEM,
          page: () => ListItemView(),
          binding: ListItemBinding(),
        ),
        GetPage(
          name: _Paths.CREATE_ITEM,
          page: () => CreateItemView(),
          binding: CreateItemBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.UNIT,
      page: () => UnitView(),
      binding: UnitBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_UNIT,
          page: () => CreateUnitView(),
          binding: CreateUnitBinding(),
        ),
        GetPage(
          name: _Paths.LIST_UNIT,
          page: () => ListUnitView(),
          binding: ListUnitBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.CUSTOMER,
      page: () => CustomerView(),
      binding: CustomerBinding(),
      children: [
        GetPage(
          name: _Paths.LIST_CUSTOMER,
          page: () => ListCustomerView(),
          binding: ListCustomerBinding(),
        ),
        GetPage(
          name: _Paths.CREATE_CUSTOMER,
          page: () => CreateCustomerView(),
          binding: CreateCustomerBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SUPPLIER,
      page: () => SupplierView(),
      binding: SupplierBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_SUPPLIER,
          page: () => CreateSupplierView(),
          binding: CreateSupplierBinding(),
        ),
        GetPage(
          name: _Paths.LIST_SUPPLIER,
          page: () => ListSupplierView(),
          binding: ListSupplierBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ITEM_VARIANT,
      page: () => ItemVariantView(),
      binding: ItemVariantBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_ITEM_VARIANT,
          page: () => CreateItemVariantView(),
          binding: CreateItemVariantBinding(),
        ),
        GetPage(
          name: _Paths.LIST_ITEM_VARIANT,
          page: () => ListItemVariantView(),
          binding: ListItemVariantBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ITEM_CATEGORY,
      page: () => ItemCategoryView(),
      binding: ItemCategoryBinding(),
      children: [
        GetPage(
          name: _Paths.LIST_ITEM_CATEGORY,
          page: () => ListItemCategoryView(),
          binding: ListItemCategoryBinding(),
        ),
        GetPage(
          name: _Paths.CREATE_ITEM_CATEGORY,
          page: () => CreateItemCategoryView(),
          binding: CreateItemCategoryBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PURCHASED_ITEM,
      page: () => PurchasedItemView(),
      binding: PurchasedItemBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_PURCHASED_ITEM,
          page: () => CreatePurchasedItemView(),
          binding: CreatePurchasedItemBinding(),
        ),
        GetPage(
          name: _Paths.LIST_PURCHASED_ITEM,
          page: () => ListPurchasedItemView(),
          binding: ListPurchasedItemBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.DIARY,
      page: () => DiaryView(),
      binding: DiaryBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_DIARY,
          page: () => CreateDiaryView(),
          binding: CreateDiaryBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.COMPANY,
      page: () => CompanyView(),
      binding: CompanyBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_COMPANY,
          page: () => CreateCompanyView(),
          binding: CreateCompanyBinding(),
        ),
        GetPage(
          name: _Paths.LIST_COMPANY,
          page: () => ListCompanyView(),
          binding: ListCompanyBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.GODOWN,
      page: () => GodownView(),
      binding: GodownBinding(),
      children: [
        GetPage(
          name: _Paths.LIST_GODOWN,
          page: () => ListGodownView(),
          binding: ListGodownBinding(),
        ),
        GetPage(
          name: _Paths.CREATE_GODOWN,
          page: () => CreateGodownView(),
          binding: CreateGodownBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ALMIRAH,
      page: () => AlmirahView(),
      binding: AlmirahBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_ALMIRAH,
          page: () => CreateAlmirahView(),
          binding: CreateAlmirahBinding(),
        ),
        GetPage(
          name: _Paths.LIST_ALMIRAH,
          page: () => ListAlmirahView(),
          binding: ListAlmirahBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.CUSTOMER_CATEGORY,
      page: () => CustomerCategoryView(),
      binding: CustomerCategoryBinding(),
      children: [
        GetPage(
          name: _Paths.LIST_CUSTOMER_CATEGORY,
          page: () => ListCustomerCategoryView(),
          binding: ListCustomerCategoryBinding(),
        ),
        GetPage(
          name: _Paths.CREATE_CUSTOMER_CATEGORY,
          page: () => CreateCustomerCategoryView(),
          binding: CreateCustomerCategoryBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.STORE_ROOM,
      page: () => StoreRoomView(),
      binding: StoreRoomBinding(),
      children: [
        GetPage(
          name: _Paths.CREATE_STORE_ROOM,
          page: () => CreateStoreRoomView(),
          binding: CreateStoreRoomBinding(),
        ),
        GetPage(
          name: _Paths.LIST_STORE_ROOM,
          page: () => ListStoreRoomView(),
          binding: ListStoreRoomBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PURCHASE_ORDER,
      page: () => PurchaseOrderView(),
      binding: PurchaseOrderBinding(),
      children: [
        GetPage(
          name: _Paths.LIST_PURCHASE_ORDER,
          page: () => ListPurchaseOrderView(),
          binding: ListPurchaseOrderBinding(),
        ),
        GetPage(
          name: _Paths.CREATE_PURCHASE_ORDER,
          page: () => CreatePurchaseOrderView(),
          binding: CreatePurchaseOrderBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.RECEIPT,
      page: () => ReceiptView(),
      binding: ReceiptBinding(),
      children: [
        GetPage(
          name: _Paths.UPDATE_RECEIPT,
          page: () => UpdateReceiptView(),
          binding: UpdateReceiptBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SALES_ORDER,
      page: () => SalesOrderView(),
      binding: SalesOrderBinding(),
    ),
    GetPage(
      name: _Paths.PDF,
      page: () => PdfView(),
      binding: PdfBinding(),
    ),
  ];
}
