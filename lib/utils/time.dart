
class Time{
  DateTime now = DateTime.now();

  String getCurrentHours(){
    now = DateTime.now();
    print(now.hour);
    return now.hour.toString();
  }
}

