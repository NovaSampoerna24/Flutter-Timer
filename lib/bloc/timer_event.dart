
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TimerEvent extends Equatable{
  const TimerEvent();
  List<Object> get props => [];
}
class Start extends TimerEvent{
  final int duration;
  const Start({@required this.duration});
  String toString()=>'Start {duration:$duration}';
}
class Pause extends TimerEvent{}
class Resume extends TimerEvent{}
class Reset extends TimerEvent{}

class Tick extends TimerEvent{
  final int duration;
  const Tick({@required this.duration});

  List<Object> get props => [duration];
  String toString()=>'Tict {duration:$duration}';
  
}