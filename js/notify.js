var Notify = function() {}
Notify.success = function(title, message) {
    iziToast.success({
        title: title,
        message: message
    });
}
Notify.info = function(title, message) {
    iziToast.warning({
        title: title,
        message: message
    });
}
Notify.error = function(title, message) {
    iziToast.error({
        title: title,
        message: message
    });
}