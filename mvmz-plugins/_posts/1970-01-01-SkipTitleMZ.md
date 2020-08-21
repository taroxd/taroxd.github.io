
```javascript
//=============================================================================
// SkipTitleMZ.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc Skip Title.
 * @author taroxd
 *
 * @param Test Only
 * @desc Whether to skip title only in playtest. true/false
 * @type boolean
 * @default true
 *
 * @help This plugin does not provide plugin commands.
 */

;(() => {
    const parameters = PluginManager.parameters('SkipTitle')
    const testOnly = parameters['Test Only'] !== 'false'
    const enable = !testOnly || Utils.isOptionValid("test")

    if (enable) {
        Scene_Boot.prototype.startNormalGame = function() {
            this.checkPlayerLocation()
            DataManager.setupNewGame()
            SceneManager.goto(Scene_Map)
        }
    }
})()

```
