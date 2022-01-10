/* ================================================================================================================== */
/*  Solitics mobile JS content , JSMonitor_tags.js                                                                    */
/* ================================================================================================================== */
function onPopupEventTrigger(element,message,event) {
    if (event) { event.stopPropagation(); }
    let payload = { "type" : "action_trigger" , "message" : message };
    window.webkit.messageHandlers.handler_trigger.postMessage(payload);
}
/* ================================================================================================================== */
function onPopupEventDismiss(element,message,event) {
    if (event) { event.stopPropagation(); }
    let payload = { "type" : "action_dismiss" };
    window.webkit.messageHandlers.handler_exit.postMessage(payload);
}
/* ================================================================================================================== */
function main_load() {
    var i = 0;
    var content_container = window.document;
    window.solitics_mobile = window.solitics_mobile || {};
    window.solitics_mobile.container_tags_a          = window.solitics_mobile.container_tags_a          || content_container.getElementsByTagName("a");
    window.solitics_mobile.container_tags_button     = window.solitics_mobile.container_tags_button     || content_container.getElementsByTagName("button");
    window.solitics_mobile.container_tags_image      = window.solitics_mobile.container_tags_image      || content_container.getElementsByTagName("img");
    window.solitics_mobile.container_tags_background = window.solitics_mobile.container_tags_background || content_container.querySelectorAll('*[style*="background-image"]');
    /* ============================================================================================================== */
    var tags_a_container = window.solitics_mobile.container_tags_a;
    if (tags_a_container && tags_a_container.length > 0) {
        for (i = 0; i < tags_a_container.length; i++) {
            tags_a_container[i].addEventListener("click", function (event) {
                onPopupEventTrigger(this, 'hyper link click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */
    var tags_button_container = window.solitics_mobile.container_tags_button;
    if (tags_button_container && tags_button_container.length > 0) {
        for (i = 0; i < tags_button_container.length; i++) {
            tags_button_container[i].addEventListener("click", function (event) {
                onPopupEventTrigger(this, 'button click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */
    var tags_image_container = window.solitics_mobile.container_tags_image;
    if (tags_image_container && tags_image_container.length > 0) {
        for (i = 0; i < tags_image_container.length; i++) {
            tags_image_container[i].addEventListener("click", function (event) {
                onPopupEventTrigger(this, 'image click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */
    var tags_background_image_container = window.solitics_mobile.container_tags_background;
    if (tags_background_image_container && tags_background_image_container.length > 0) {
        for (i = 0; i < tags_background_image_container.length; i++) {
            tags_background_image_container[i].addEventListener("click", function (event) {
                onPopupEventTrigger(this, 'background image click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */
    var exit_container = content_container.querySelector(".popup__exit");
    if (exit_container) {
        exit_container.addEventListener("click", function (event) {
            onPopupEventDismiss(this, "dismiss click Detected!", event);
        }, false);
    }
    /* ============================================================================================================== */
}
addLoadWindowEvent(main_load)
