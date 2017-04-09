-module(pollution).

-record(station, {long, lat, measures=[]}).
-record(measure, {type, datetime, value}).

-export([createMonitor/0, addStation/3, addValue/5, getOneValue/4]).

createMonitor() -> #{}.

addStation(Name, {Long, Lat}, Monitor) ->
    maps:put(Name, #station{long=Long, lat=Lat}, Monitor).

addValue(StationName, Datetime, Type, Value, Monitor) ->
    #station{long=Long, lat=Lat, measures=Measures} = maps:get(StationName, Monitor),
    maps:put(StationName, 
             #station{long=Long, lat=Lat, measures=[#measure{type=Type, datetime=Datetime, value=Value} | Measures]},
             Monitor).

getOneValue(StationName, Type, Datetime, Monitor) ->
    #station{long=_Long, lat=_Lat, measures=Measures} = maps:get(StationName, Monitor),
    [M] = [Value || #measure{type=MType, datetime=MDatetime, value=Value} <- Measures, MDatetime == Datetime, MType == Type],
    M.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

simple_test() ->
    Name = "Aleja Słowackiego",
    Time = calendar:local_time(),
    Type = "PM10",
    Value = 42,
    M1 = createMonitor(),
    M2 = addStation(Name, {50.2345, 18.3445}, M1),
    M3 = addValue(Name, Time, Type, Value, M2),
    ?assertEqual(Value, getOneValue(Name, Type, Time, M3)).
    
-endif.
