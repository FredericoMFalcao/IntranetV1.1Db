// @Description: class view creator. A view is object that renders itself as DOM Element, reacts to data changed, and notifies of internal events
// @param DomElementStr string the type of HTML tag for top wrapping element
// @param dynVars object an array of dynamic variables
// @param updateContentFn function a callback to be called when the underlying data (from dynVars) changes
// @param handleEventFn function? a callback to be called when some internal events (keypress, mouseclick, ...) happens
// @return null
//function view(DomElementStr, dynVars, updateContentFn, handleEventFn) {
	
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
	dom_el.updateData();
	
	/* 6. Listen to dom element events, update variable(s) */		
	if (typeof handleEventFn != "undefined")
		dom_el.addEventListener("change", handleEventFn) 
					
	/* 10. Return Dom Element */
	return dom_el						
//}
