Stethoscope(s, 2);
ServerMeter.new(s, 4, 2);
FreqScope.new(400, 200, 0, server: s);
s.meter;
s.scope;
s.plotTree;
