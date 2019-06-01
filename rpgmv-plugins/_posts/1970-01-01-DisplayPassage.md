
```javascript
//=============================================================================
// PassageExtra.js
//=============================================================================

/*:
 * @plugindesc Display passage information in playtest.
 * @author taroxd
 *
 * @param Opacity
 * @desc No description.
 * @type number
 * @max 255
 * @min 0
 * @default 150
 *
 * @param NG Color
 * @desc The color displayed above inpassable tiles.
 * @default #ff0000
 *
 * @param OK Color
 * @desc The color displayed above passable tiles.
 * @default #0000ff
 *
 * @param NG Width
 * @desc No description.
 * @type number
 * @max 24
 * @min 0
 * @default 4
 *
 * @param Only Test
 * @desc Enable only in playtest.
 * @type Boolean
 * @default true
 *
 * @help This plugin does not provide plugin commands.
 *
 * Press Ctrl Key to display passage information.
 */

void function() {

    var parameters = PluginManager.parameters('DisplayPassage');

    var TEST_ONLY = parameters['Test Only'] !== 'false';
    var enable = !TEST_ONLY || location.search === '?test';

    if (!enable) return;

    var OPACITY = parseInt(parameters['Opacity']);
    var NG_COLOR = parameters['NG Color'];
    var OK_COLOR = parameters['OK Color'];
    var NG_WIDTH = parseInt(parameters['NG Width']);

    // Advanced options:
    // Never change it unless you know what you are doing.

    var Z = 20;

    function shouldChangeVisibility() {
        return Input.isTriggered('control');
    }

    function PassageSprite() {
        TilingSprite.call(this);
        this.visible = false;
        this.move(0, 0, Graphics.width, Graphics.height);
        this.z = Z;
        this.opacity = OPACITY;
        this.refresh();
    }

    PassageSprite.prototype = Object.create(TilingSprite.prototype);
    PassageSprite.prototype.constructor = PassageSprite;

    PassageSprite.prototype.update = function() {
        if (shouldChangeVisibility()) {
            this.visible = !this.visible;
        }

        this.origin.x = $gameMap.displayX() * $gameMap.tileWidth();
        this.origin.y = $gameMap.displayY() * $gameMap.tileHeight();
    };

    PassageSprite.prototype.refresh = function() {
        var w = $gameMap.width();
        var h = $gameMap.height();
        this.bitmap = new Bitmap(
            w * $gameMap.tileWidth(),
            h * $gameMap.tileHeight());

        for (var x = 0; x < w; ++x) {
            for (var y = 0; y < h; ++y) {
                this.drawPoint(x, y);
            }
        }
    };

    PassageSprite.prototype.drawPoint = function(x, y) {
        var ngDirs = [2, 4, 6, 8].filter(function(d) {
            return !$gameMap.isPassable(x, y, d);
        });

        var bitmap = this.bitmap;
        var tw = $gameMap.tileWidth();
        var th = $gameMap.tileHeight();

        if (ngDirs.length === 4) {
            bitmap.fillRect(x * tw, y * th, tw, th, NG_COLOR);
            return;
        }

        bitmap.fillRect(x * tw, y * th, tw, th, OK_COLOR);

        ngDirs.forEach(function(d) {
            var dx = d === 6 ? tw - NG_WIDTH : 0;
            var dy = d === 2 ? th - NG_WIDTH : 0;
            var w, h;
            if (d === 2 || d === 8) {
                w = tw;
                h = NG_WIDTH;
            } else {
                w = NG_WIDTH;
                h = tw;
            }
            bitmap.fillRect(x * tw + dx, y * th + dy, w, h, NG_COLOR);
        });
    };

    var ct = Spriteset_Map.prototype.createTilemap;
    Spriteset_Map.prototype.createTilemap = function() {
        ct.call(this);
        this._tilemap.addChild(new PassageSprite);
    };
}();

```
