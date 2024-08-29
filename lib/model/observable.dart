import 'package:pocket_pal/interface/subscriber.dart';

class Observable {
  final List<Subscriber> subscribers = [];

  void subscribe(Subscriber sub) {
    if (!subscribers.contains(sub)) subscribers.add(sub);
  }

  void unsubscribe(Subscriber sub) {
    if (subscribers.contains(sub)) subscribers.remove(sub);
  }

  void notifySubscribers() {
    subscribers.forEach((element) => element.update());
  }
}
