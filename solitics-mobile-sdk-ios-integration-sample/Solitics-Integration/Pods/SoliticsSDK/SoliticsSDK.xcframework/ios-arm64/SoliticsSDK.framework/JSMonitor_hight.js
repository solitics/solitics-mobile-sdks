/* ================================================================================================================== */
/*  Solitics mobile JS content , JSMonitor_hight.js                                                                   */
/* ================================================================================================================== */
function compute_height_OnLoad() {
    let payload = {
        "type" : "action_height" ,
        "bodyScrollHeight" : `${document.body.scrollHeight}`,
        "documentScrollHeight" : `${document.documentElement.scrollHeight}`
    };
    window.webkit.messageHandlers.handler_height.postMessage(payload);
}
addLoadWindowEvent(compute_height_OnLoad)
