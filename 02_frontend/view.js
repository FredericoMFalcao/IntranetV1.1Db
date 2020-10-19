// @Description: a base view's contructor expects:
//			1. an initial data object
//			2. a full render callback function that receives:
//				2.1 the top "dom_el" to overwrite
//				2.2 a list of arguments with static data
//			3. a listening callback function that reacts to partial data updates. It expects:
//				3.1 the top "dom_el" to manipulate
//				3.2 the variable that changed and triggered this function
//			4. an array of event names to capture
//			5. a listening callback function that reacts to events
//
//
// @param DomElementStr string the type of HTML tag for top wrapping element
// @param dynVars object an array of dynamic variables
// @param updateContentFn function a callback to be called when the underlying data (from dynVars) changes
// @param handleEventFn function? a callback to be called when some internal events (keypress, mouseclick, ...) happens
// @return null
// function view(DomElementStr, dynVars, updateContentFn, handleEventFn) {
	/* 0. Check types */
	if (typeof DomElementStr != "string") throw "DomElementStr expected to be string";
	if (typeof dynVars != "object") throw "dynVars expected to be array";
	if (typeof updateContentFn != "function") throw "updateContentFn expected to be function";
	if (!["function","undefined"].includes(typeof handleEventFn)) throw "handleEventFn expected to be function or undefined";		
	
	/* 1. Create the DOM element */
	var dom_el = document.createElement(DomElementStr);
	/* 2. Define the content generation function */
	dom_el.updateData = updateContentFn;
	/* 3. Listen to dependent variable changes */
	dom_el.listening_keys = []
	for(k in dynVars)
		dom_el.listening_keys.push(dynVars[k].addListener(dom_el.updateData, dom_el));
	/* 4. Register an unload function */
	dom_el.unload_listeners = function () {
		for(k in dynVars)
			listening_keys.push(dynVars[k].removeListener(dom_el.listening_keys));			
	}
	/* 5. Force an initial update */
	dom_el.updateData(dom_el);
	
	/* 6. Listen to dom element events, update variable(s) */		
	if (typeof handleEventFn != "undefined")
		dom_el.addEventListener("change", handleEventFn) 
					
	/* 10. Return Dom Element */
	return dom_el						
// }

