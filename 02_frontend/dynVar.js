// @Description: class builder of DynVar - dynamic variable - a variable that notifies its users when data changes
// @return Object
// function dynVar() {
	return {
			"_value":"",
			"get": function() { return this._value;}, 
			"set": function(v){	this._value = v; for (k in this._listners) this._listners[k](v); return this;},
			"_listners":{},
			"addListener": function (fn,obj){
				// Generate unique/not-used key for _listners object
				do {key = Math.floor(Math.random()*1000).toString(16);} 
				while (typeof this._listners[key] != "undefined");
				// Add the function
				this._listners[key] = fn.bind(obj);
				// return the key associated, useful to remove the listener
				return key;
			},
			"removeListener": function(key) {
				delete this._listners[key];
			}
		};
// }
