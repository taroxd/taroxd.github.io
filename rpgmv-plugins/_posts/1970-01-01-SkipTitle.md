
```javascript
//=============================================================================
// SkipTitle.js
//=============================================================================

/*:
 * @plugindesc Skip Title.
 * @author taroxd
 *
 * @param Test Only
 * @desc Whether to skip title only in playtest. true/false
 * @default true
 *
 * @help This plugin does not provide plugin commands.
 */

void function() {

    var parameters = PluginManager.parameters('SkipTitle');
    var testOnly = parameters['Test Only'] !== 'false';
    var enable = !testOnly || location.search === '?test';

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
