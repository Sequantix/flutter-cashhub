import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  String idss;
  StripeTransactionResponse({this.message, this.success,this.idss});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  // static String secret = 'sk_test_51IMGAjA7jHm1VAe8OHFl1RlSeS8IR7B8vKiKQAzlhijXYcGbTYpvFsTqBck46KDfyEwnYg4VkxfX14lsP8u6grPW001RP5XCyT';
  static String secret = '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';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
        StripeOptions(
            publishableKey: "pk_live_51IMGAjA7jHm1VAe8SKOdG86y9nGsmivhM3bvKLZNCXRA3hT3zb6WUr3NHYbpg6QbUvasmb4dDhb0zPA7jMXNh3qn00LLdf6NNQ",
            // publishableKey: "pk_test_51IMGAjA7jHm1VAe8ep5rNbiXowlekGhFACjC5wa8X3EA65GnbBhosLcDcoTkgM5ajn9PAbTHQHwTTefzFrhEbe0i00lKUWb5KH",
            // merchantId: "Test",
            // androidPayMode: 'test'
        )
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard({String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest()
      );
      var paymentIntent = await StripeService.createPaymentIntent(
          amount,
          currency
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true,
            idss:  paymentIntent['id']
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
        message: message,
        success: false
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          StripeService.paymentApiUrl,
          body: body,
          headers: StripeService.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}
