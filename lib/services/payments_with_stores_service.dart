import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseClass {
  final InAppPurchaseConnection _inAppPurchase =
      InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  final String _kConsumableId = 'assinatura_livraria_sabia';
  ValueNotifier<bool> userPremium = ValueNotifier<bool>(false);
  List<ProductDetails> _productsList = [];
  List<String> _kProductIds = [];

  Future<void> initInAppPurchase() async {
    _kProductIds = <String>[_kConsumableId];
    await _initStoreInfo();
    await checkStatus();
    await _streamToGetUpdatePurchase();
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> triggerOpenPurshase() async {
    await checkStatus();
    if (_productsList.isEmpty) {
      log("Nenhum produto cadastrado");
      return;
    }
    PurchaseParam purchaseParam;
    purchaseParam = PurchaseParam(
      productDetails: _productsList[0],
      applicationUserName: null,
    );
    if (_productsList[0].id == _kConsumableId) {
      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } else {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> checkStatus() async {
    await _inAppPurchase.queryPastPurchases().then((value) {
      if (value.pastPurchases.isNotEmpty) {
        log(value.pastPurchases.toString());
        PurchaseDetails findElement = value.pastPurchases
            .firstWhere((element) => element.productID == _kConsumableId);
        if (findElement != null) {
          if (findElement.productID.toString() == _kConsumableId) {
            _isDoneBuy(findElement);
          }
        } else {
          userPremium.value = false;
        }
      } else {
        userPremium.value = false;
      }
    });
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _productsList = [];
      return;
    }
    ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    log("---------------------" +
        productDetailResponse.productDetails.toString() +
        "---------------------");
    if (productDetailResponse.error != null) {
      _productsList = productDetailResponse.productDetails;
      return;
    }
    _productsList = productDetailResponse.productDetails;
  }

  void _streamToGetUpdatePurchase() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      log("---------------  OnDone ------------------");
      _subscription.cancel();
    }, onError: (error) {
      log("---------------  onError ------------------");
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          log(" ------------------ COMPRA PENDENTE ----------------------");
          break;
        case PurchaseStatus.error:
          log(purchaseDetails.error.message.toString());
          if (purchaseDetails.error.message.toString() ==
              BillingResponse.itemAlreadyOwned.toString()) {
            log(" ------------------ COMPRA JÁ FEITA ----------------------");
            _isDoneBuy(purchaseDetails);
          } else {
            log(" ------------------ COMPRA FALHOU ----------------------");
          }
          break;
        case PurchaseStatus.purchased:
          log(" ------------------ COMPRA FEITA ----------------------");
          _isDoneBuy(purchaseDetails);
          break;
        default:
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }

  void _isDoneBuy(PurchaseDetails purchaseDetails) {
    userPremium.value = true;
  }
}
