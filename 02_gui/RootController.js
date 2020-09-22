// @Description: this is the main controller of the application
// @param simpleString1 string this a a simple test string one
// @param simpleString2 string this a a simple test string two
// @return string
// function RootController() {
return {
	"renderDOM": function() { 
		var el = document.createElement("span"); 
		el.innerText = "Hello! The \"last build dashboard\" moved to /last_build.php "; 
		return el; 
	}
}
// }
