var Action = function() { }

Action.prototype = {
    
run: function(parameters) {
    // parameters.completionFunction tells iOS that the JS has complete its pre-processing. The code inside braces means "give this data dictionary back to the extension"
    parameters.completionFunction({"URL": document.URL, "title": document.title});
},
    
finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"];
    // eval executes the JS code  written by the user as soon as the user taps on "Done"
    eval(customJavaScript)
}
    
};

var ExtensionPreprocessingJS = new Action
