
```javascript
//=============================================================================
// AlwaysZeroParallax.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc Fixes all parallax backgrounds in place.
 * @author taroxd
 *
 * @help AlwaysZeroParallax.js
 *
 * This plugin makes every parallax behave as a zero parallax.
 * It does not provide plugin commands or parameters.
 */

(() => {
    ImageManager.isZeroParallax = function() {
        return true;
    };
})();

```
