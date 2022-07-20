import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsStore {
  final FirebaseAnalytics firebaseAnalytics;

  AnalyticsStore(this.firebaseAnalytics);

  Future<void> logEvent({String name, Map<String, dynamic> parameters}) async {
    await this.firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logLogin(method) => this.logEvent(name: "login", parameters: {
        "method": method,
      });
  Future<void> logSignup(method) => this.logEvent(name: "sign_up", parameters: {
        "method": method,
      });

  Future<void> logSelectedContent({type, id}) =>
      this.logEvent(name: "select_content", parameters: {
        "content_type": type,
        "item_id": id,
      });

  Future<void> logShare({type, id}) =>
      this.logEvent(name: "share", parameters: {
        "content_type": type,
        "item_id": id,
      });

  Future<void> logSearch(searchTerm) async {
    if (searchTerm.length < 3) return;
    return this.logEvent(name: "search", parameters: {
      "search_term": searchTerm,
    });
  }
}
