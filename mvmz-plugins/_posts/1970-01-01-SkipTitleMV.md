
```javascript
//=============================================================================
// SkipTitleMV.js
//=============================================================================

/*:
 * @plugindesc Skip Title.
 * @author taroxd
 *
 * @param Test Only
 * @desc Whether to skip title only in playtest. true/false
 * @type boolean
 * @default true
 *
 * @help This plugin does not provide plugin commands. RPG Maker MZ is not supported.
 */

void function() {

    var parameters = PluginManager.parameters('SkipTitle');
    var testOnly = parameters['Test Only'] !== 'false';
    var enable = !testOnly || Utils.isOptionValid("test");

    if (enable) {
        Scene_Boot.prototype.start = function() {
            Scene_Base.prototype.start.call(this);
            SoundManager.preloadImportantSounds();
            this.checkPlayerLocation();
            DataManager.setupNewGame();
            SceneManager.goto(Scene_Map);
        };
    }

}();

```
