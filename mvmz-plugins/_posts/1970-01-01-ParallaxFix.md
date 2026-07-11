
```javascript
//=============================================================================
// ParallaxFix.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc Keeps parallax changes and screen shake from exposing blank edges.
 * @author taroxd
 *
 * @help ParallaxFix.js
 *
 * When an event command or $gameMap.changeParallax changes the parallax, RPG Maker MZ updates the parallax sprite while the new image is still loading.
 * Its width and height are zero at that point, which can make the parallax disappear briefly.
 *
 * This plugin keeps the old parallax visible until the new image finishes loading.
 * When parallaxes are changed repeatedly in quick succession, obsolete load requests cannot overwrite the latest parallax.
 * It also compensates screen shake so the parallax does not expose blank canvas edges.
 *
 * This plugin has no parameters or plugin commands.
 */

(() => {
    Spriteset_Map.prototype.parallaxFixUpdateFrame = function(shake) {
        const x = -shake;
        const width = Graphics.width;
        const height = Graphics.height;

        if (
            this._parallaxFixX !== x ||
            this._parallaxFixWidth !== width ||
            this._parallaxFixHeight !== height
        ) {
            this._parallaxFixX = x;
            this._parallaxFixWidth = width;
            this._parallaxFixHeight = height;
            this._parallax.move(x, 0, width, height);
        }
    };

    Spriteset_Map.prototype.parallaxFixEffectiveShakeX = function(bitmap, originX, shake) {
        if (this._parallaxFixLoopX) {
            return shake;
        }

        if (shake > 0) {
            return Math.min(shake, Math.max(0, originX));
        } else if (shake < 0) {
            const rightEdge = originX + Graphics.width;
            return -Math.min(-shake, Math.max(0, bitmap.width - rightEdge));
        } else {
            return 0;
        }
    };

    Spriteset_Map.prototype.updateParallax = function() {
        const name = $gameMap.parallaxName();
        const shake = Math.round($gameScreen.shake());

        this.parallaxFixUpdateFrame(shake);

        if (this._pendingParallaxName !== name) {
            this._pendingParallaxName = name;

            const requestId = (this._parallaxRequestId || 0) + 1;
            const bitmap = ImageManager.loadParallax(name);
            const parallax = this._parallax;

            this._parallaxRequestId = requestId;

            bitmap.addLoadListener(() => {
                const isCurrentRequest = this._parallaxRequestId === requestId && $gameMap.parallaxName() === name;
                const isAlive = this._parallax === parallax && parallax.texture;

                if (isCurrentRequest && isAlive) {
                    this._parallaxName = name;
                    this._parallaxFixLoopX = $gameMap._parallaxLoopX;
                    parallax.bitmap = bitmap;
                }
            });
        }

        if (this._parallaxName === name) {
            const bitmap = this._parallax.bitmap;

            if (bitmap && bitmap.width > 0 && bitmap.height > 0) {
                const originX = $gameMap.parallaxOx() % bitmap.width;
                this._parallaxFixLoopX = $gameMap._parallaxLoopX;

                const effectiveShake = this.parallaxFixEffectiveShakeX(bitmap, originX, shake);

                this._parallax.origin.x = originX - effectiveShake;
                this._parallax.origin.y = $gameMap.parallaxOy() % bitmap.height;
            }
        }
    };
})();

```
