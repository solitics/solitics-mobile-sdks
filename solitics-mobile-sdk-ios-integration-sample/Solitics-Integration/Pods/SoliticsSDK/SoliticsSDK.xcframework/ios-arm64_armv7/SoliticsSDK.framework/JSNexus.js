/* ================================================================================================================== */
/*  Solitics mobile JS content, global                                                                                */
/* ================================================================================================================== */
function addLoadWindowEvent(handler) {

    var oldOnLoad = window.onload;
    var newOnLoad;

    if (typeof window.onload != 'function') {
        newOnLoad = handler;
    } else {
        newOnLoad = function () { if (oldOnLoad) { oldOnLoad(); }; handler(); }
    }
    window.onload = newOnLoad
}
