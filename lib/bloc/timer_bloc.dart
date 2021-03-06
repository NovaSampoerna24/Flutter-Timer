
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_timer/bloc/bloc.dart';
import 'package:flutter_timer/ticker.dart';

class TimerBloc extends Bloc<TimerEvent,TimerState>{

  final Ticker _ticker;
  final int _duration = 60;

  StreamSubscription<int> _tickerSubcription;
  TimerBloc({@required Ticker ticker}):assert(ticker!=null),_ticker=ticker;

  TimerState get initialState => Ready(_duration);
   // TODO: implement initialState;

  @override
  Stream<TimerState> mapEventToState(TimerEvent event,)async*{
    if(event is Start){
      yield* _mapStartToState(event);
    }else if(event is Tick){
      yield* _mapTickToState(event);
    }else if(event is Pause){
      yield* _mapPauseToState(event);
    }else if(event is Resume){
      yield* _mapResumeToState(event);
    }else if(event is Reset){
      yield* _mapResetToState(event);
    }
  }
  Future<void> close(){
    _tickerSubcription?.cancel();
    return super.close();
  }
  Stream<TimerState> _mapStartToState(Start start)async*{
    yield Running(start.duration);
    _tickerSubcription?.cancel();
    _tickerSubcription = _ticker
    .tick(ticks: start.duration)
    .listen((duration)=>add(Tick(duration: duration)));
  }
  Stream<TimerState> _mapTickToState(Tick tick)async*{
    yield tick.duration > 0 ? Running(tick.duration):Finished();
  }
  Stream<TimerState> _mapPauseToState(Pause pause)async*{
    if(state is Running){
      _tickerSubcription?.pause();
      yield Paused(state.duration);
    }
  }
  Stream<TimerState> _mapResumeToState(Resume resume)async*{
    if(state is Paused){
      _tickerSubcription?.resume();
      yield Running(state.duration);
    }
  }
  Stream<TimerState> _mapResetToState(Reset reset)async*{
    _tickerSubcription?.cancel();
    yield Ready(_duration);
  }

}