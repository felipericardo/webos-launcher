// Home redirect key filter for the webOS 4.x compositor (YSM).
// Loaded through com.webos.surfacemanager.keyFilters, placed first in the
// chain. Every path where a key would open the native Home ribbon opens
// TARGET_APP instead:
//   - Home key (systemUi.js handleSystemKeys -> global.goHome on release)
//   - Back key on an app that doesn't handle Back (systemUi.js emits
//     signals.backReleased -> ysm.goHome)

var TARGET_APP = "tld.my.customlauncher";

function init() {
    console.warn("HOME_REDIRECT: loaded, target=" + TARGET_APP);
}

function systemOwnsKeys() {
    // Same gating LG applies to its own app-launch keys.
    return modalAlert.visible || !access.keyAction.launchApp
        || (bootManager.bootFirstUse && !systemPropertyService.powerOnlyMode);
}

function openTarget() {
    if (!global.isForegroundApp(TARGET_APP)) {
        applicationManager.checkLaunch(TARGET_APP);
    }
    global.hideHome();
}

// Mirrors activeSurfaceAcceptsBackKey() in systemUi.js.
function activeSurfaceAcceptsBack() {
    var appId = global.activeSurfaceAppId;
    if (global.isPartOfGroup(appId))
        appId = global.getSurfaceGroupRootItem(appId);
    return global.surfaceAcceptsBackKey(appId) === "true";
}

// True only in the exact case where systemUi.js would turn Back into goHome:
// nothing on screen that Back should close, ribbon hidden, and the active
// app doesn't handle Back itself.
function backWouldGoHome() {
    if (voiceAgent.isRunning() || keyboard.visible || pincodePrompt.visible
            || alert.visible || advancedAlert.visible || globalActions.visible
            || appSpinner.visible || remoteUserToolTip.visible || superRibbon.visible)
        return false;
    return !activeSurfaceAcceptsBack();
}

function handleHomeRedirect(key, pressed, autoRepeat) {
    if (key !== Qt.Key_Super_L && key !== WebOS.Key_webOS_Back)
        return KeyPolicy.NextPolicy;

    try {
        if (systemOwnsKeys())
            return KeyPolicy.NextPolicy;

        if (key === Qt.Key_Super_L) {
            if (pressed && !autoRepeat)
                openTarget();
            // Consume press and release: the native ribbon opens on release
            // (systemUi.js) or in the fallback handler.
            return KeyPolicy.Accepted;
        }

        if (!backWouldGoHome())
            return KeyPolicy.NextPolicy;
        if (!pressed)
            openTarget();
        return KeyPolicy.Accepted;
    } catch (e) {
        // Never strand the remote on a bug here: fall back to native.
        console.warn("HOME_REDIRECT: error, falling back to native: " + e);
        return KeyPolicy.NextPolicy;
    }
}
