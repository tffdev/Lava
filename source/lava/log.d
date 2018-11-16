module log;

import lava;
import std.stdio;
import std.format;
import core.vararg;
import core.stdc.stdlib;

bool LOG_ALL = true;

void _log(T...)(T args){
  if(LOG_ALL){
    string _outputMessage = format(args);
    writeln(_outputMessage);
  }
}