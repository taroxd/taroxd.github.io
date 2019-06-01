
```javascript
//=============================================================================
// RegionPassage.js
//=============================================================================

/*:
 * @plugindesc Provide advanced options for tile passage.
 * @author taroxd
 *
 * @param Passable Regions
 * @desc Tiles are always passable in these regions.
 * @type number[]
 * @max 255
 * @min 0
 * @default []
 *
 * @param Impassable Regions
 * @desc Tiles are always not passable in these regions.
 * @type number[]
 * @max 255
 * @min 0
 * @default []
 *
 * @help This plugin does not provide plugin commands.
 */

void function() {

    var parameters = PluginManager.parameters('RegionPassage');
    var PASSABLE_REGIONS = JSON.parse(parameters['Passable Regions'])
    var IMPASSABLE_REGIONS = JSON.parse(parameters['Impassable Regions'])

    var REGIONS = {};
    PASSABLE_REGIONS.forEach(function(r) {
        REGIONS[r] = true;
    });
    IMPASSABLE_REGIONS.forEach(function(r) {
        REGIONS[r] = false;
    });

    /* Advanced options:
     *
     * REGIONS[r] = function(regionId)
     *
     * The function determines whether it is possible
     * to go to region `regionId' from region `r'.
     * If the return value is true,
     * then it is always possible regardless of the tile.
     * If the return value is false,
     * then it is always not possible regardless of the tile.
     * Any other return value will leave the passage settings unchanged.
     *
     * For example,
     * Region 3 can be entered from and only from region 4.
     * And Tiles are always passable in region 3.
     * REGIONS[3] = function(r) { return r === 3 || r === 4; };
     *
     * You cannot walk between region 5 and region 6.
     * REGIONS[5] = function(r) { return r !== 6 && null };
     */

    var enable = Object.keys(REGIONS).length > 0;
    if (!enable) return;

    var ip = Game_Map.prototype.isPassable;
    Game_Map.prototype.isPassable = function(x, y, d) {
        var settings = REGIONS[$gameMap.regionId(x, y)];
        if (typeof(settings) === 'function') {
            var x2 = $gameMap.roundXWithDirection(x, d);
            var y2 = $gameMap.roundYWithDirection(y, d);
            settings = settings($gameMap.regionId(x2, y2));
        }
        if (typeof(settings) === 'boolean') {
            return settings;
        }
        return ip.call(this, x, y, d);
    };
}();

```
