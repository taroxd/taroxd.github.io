
```javascript
//=============================================================================
// ParallaxFix.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc Keeps the old parallax visible until the new one is loaded.
 * @author taroxd
 *
 * @help ParallaxFix.js
 *
 * When an event command or $gameMap.changeParallax changes the parallax,
 * RPG Maker MZ updates the parallax sprite while the new image is still
 * loading. Its width and height are zero at that point, which can make the
 * parallax disappear briefly.
 *
 * This plugin keeps the old parallax visible until the new image finishes
 * loading. When parallaxes are changed repeatedly in quick succession,
 * obsolete load requests cannot overwrite the latest parallax.
 *
 * This plugin has no parameters or plugin commands.
 */

(() => {
    Spriteset_Map.prototype.updateParallax = function() {
        const name = $gameMap.parallaxName();

        if (this._pendingParallaxName !== name) {
            this._pendingParallaxName = name;

            const requestId = (this._parallaxRequestId || 0) + 1;
            const bitmap = ImageManager.loadParallax(name);
            const parallax = this._parallax;

            this._parallaxRequestId = requestId;

            bitmap.addLoadListener(() => {
                const isCurrentRequest =
                    this._parallaxRequestId === requestId &&
                    $gameMap.parallaxName() === name;
                const isAlive =
                    this._parallax === parallax &&
                    parallax.texture;

                if (isCurrentRequest && isAlive) {
                    this._parallaxName = name;
                    parallax.bitmap = bitmap;
                }
            });
        }

        if (this._parallaxName === name) {
            const bitmap = this._parallax.bitmap;

            if (bitmap && bitmap.width > 0 && bitmap.height > 0) {
                this._parallax.origin.x =
                    $gameMap.parallaxOx() % bitmap.width;
                this._parallax.origin.y =
                    $gameMap.parallaxOy() % bitmap.height;
            }
        }
    };
})();

```
