
```javascript
//=============================================================================
// ParallaxFix.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc 新远景图加载完成后再替换旧远景图，避免切换时画面闪烁。
 * @author taroxd
 *
 * @help ParallaxFix.js
 *
 * 使用“更改远景图”事件指令或 $gameMap.changeParallax 时，
 * RPG Maker MZ 会在新图片仍处于加载状态时更新远景图精灵。
 * 此时图片宽高为 0，可能使远景图短暂消失。
 *
 * 本插件会继续显示旧远景图，直到新远景图加载完成后再进行替换。
 * 快速连续切换远景图时，已经过期的加载请求不会覆盖最新远景图。
 *
 * 本插件没有插件参数和插件命令。
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
