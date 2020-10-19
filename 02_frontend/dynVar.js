// @Description: class builder of DynVar - dynamic variable - a variable that notifies its users when data changes
// @return Object
// function dynVar() {
	return {
				"_value":"",
				"get": function() { return this._value;}, 
				"clear": function(){ this._value = ""; },
				"set": function(v){
					// If the new value (v) to be assigned is an object
					// simply merge properties
					if (typeof this._value == "object" && typeof v == "object")
						Object.assign(this._value, v);
					else
						this._value = v;
					// Calls all the listeners expecting new events with :
					//   1. the object provided at the time of the call "addListener"
					//   2. the new value
					for (k in this._listners) 
						this._listners[k][0](this._listners[k][1],this._value);
					return this;
				},
				"_listners":{},
				"addListener": function (fn,obj){
					// Generate unique/not-used key for _listners object
					do {key = Math.floor(Math.random()*1000).toString(16);} 
					while (typeof this._listners[key] != "undefined");
					// Add the function
					this._listners[key] = [fn,obj];
					// return the key associated, useful to remove the listener
					return key;
				},
				"removeListener": function(key) {
					delete this._listners[key];
				}
			};
// }
