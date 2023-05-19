/* ================================================================================================================== */
/*  Solitics mobile JS content , JSMonitor_tags.js                                                                    */
/* ================================================================================================================== */
function extractLink(a_tag) {

    function convert(href) {
        // check that href is a string, and not an empty string
        if (typeof href !== 'string' && href.length >= 3) {
            return null;
        }

        if (href[0] === '/' && href[href.length-1] === '/') {
            return href;
        }
        let prefix = 'solitics://';
        if (href.startsWith(prefix)) {
            return convert(href.substring(prefix.length));
        }
        return null;
    }

    // check that input is a valid "a" tag, if not return null
    if (!a_tag.hasAttribute('href')) {
        return null;
    }

    let href = a_tag.href;

    // get the content of the href property
    let url = convert(href);

    if (href.length > 0)
    {
        if (url !== null) {
            return url;
        }
        return href;
    }
    return null;
}
/* ================================================================================================================== */
function onPopupInformaticsReport(element,message,event) {
    if (event) { event.stopPropagation(); }
    let payload = { "type" : "action_trigger" , "message" : message };
    window.webkit.messageHandlers.handler_trigger.postMessage(payload);
}
function onPopupEventTriggerNavigation(element,message,event) {
    
    if (event) { event.stopPropagation(); event.preventDefault(); };
    
    onPopupInformaticsReport(element, message, event);
    
    let link  = extractLink(element);
    if (link != null) {
        let payload = { "type" : "action_navigation" , "message" : message , "target": link };
        window.webkit.messageHandlers.handler_trigger.postMessage(payload);
    }
}
/* ================================================================================================================== */
function onPopupDismiss(element,message,event) {
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
    window.solitics_mobile.container_tags_dismiss    = window.solitics_mobile.container_tags_dismiss    || content_container.querySelectorAll(".popup__exit");
    /* ============================================================================================================== */
    var tags_a_container = window.solitics_mobile.container_tags_a;
    if (tags_a_container && tags_a_container.length > 0) {
        for (i = 0; i < tags_a_container.length; i++) {
            tags_a_container[i].addEventListener("click", function (event) {
                onPopupEventTriggerNavigation(this, 'hyper link click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */
    var tags_button_container = window.solitics_mobile.container_tags_button;
    if (tags_button_container && tags_button_container.length > 0) {
        for (i = 0; i < tags_button_container.length; i++) {
            tags_button_container[i].addEventListener("click", function (event) {
                onPopupInformaticsReport(this, 'button click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */
    var tags_image_container = window.solitics_mobile.container_tags_image;
    if (tags_image_container && tags_image_container.length > 0) {
        for (i = 0; i < tags_image_container.length; i++) {
            tags_image_container[i].addEventListener("click", function (event) {
                onPopupInformaticsReport(this, 'image click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */
    var tags_background_image_container = window.solitics_mobile.container_tags_background;
    if (tags_background_image_container && tags_background_image_container.length > 0) {
        for (i = 0; i < tags_background_image_container.length; i++) {
            tags_background_image_container[i].addEventListener("click", function (event) {
                onPopupInformaticsReport(this, 'background image click Detected!', event);
            }, false);
        }
    };
    /* ============================================================================================================== */

    var tags_dismiss_container = window.solitics_mobile.container_tags_dismiss;
    if (tags_dismiss_container && tags_dismiss_container.length > 0) {
        for (i = 0; i < tags_dismiss_container.length; i++) {
            tags_dismiss_container[i].addEventListener("click", function (event) {
                onPopupDismiss(this, "dismiss click Detected!", event);
            }, false);
        }
    };
    /* ============================================================================================================== */
}
addLoadWindowEvent(main_load)
