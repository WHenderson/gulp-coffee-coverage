if (typeof _$jscoverage === 'undefined') _$jscoverage = {};
(function(_export) {
    if (typeof _export._$jscoverage === 'undefined') {
        _export._$jscoverage = _$jscoverage;
    }
})(typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : this);
if (! _$jscoverage["input.coffee"]) {
    _$jscoverage["input.coffee"] = [];
    _$jscoverage["input.coffee"][1] = 0;
    _$jscoverage["input.coffee"][2] = 0;
    _$jscoverage["input.coffee"][3] = 0;
    _$jscoverage["input.coffee"][5] = 0;
    _$jscoverage["input.coffee"][7] = 0;
}

_$jscoverage["input.coffee"].source = ["methodA = (x) ->", "  if x?", "    return 1", "  else", "    return 0", "", "methodA(42)"];

(function() {
  var methodA;

  _$jscoverage["input.coffee"][1]++;

  methodA = function(x) {
    _$jscoverage["input.coffee"][2]++;
    if (x != null) {
      _$jscoverage["input.coffee"][3]++;
      return 1;
    } else {
      _$jscoverage["input.coffee"][5]++;
      return 0;
    }
  };

  _$jscoverage["input.coffee"][7]++;

  methodA(42);

}).call(this);
