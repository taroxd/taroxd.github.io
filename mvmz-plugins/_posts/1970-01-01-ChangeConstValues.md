
```javascript
//=============================================================================
// ChangeConstValues.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc Changes bush depth, bush opacity, and basic floor damage.
 * @author taroxd
 *
 * @param bushDepthVariable
 * @text Bush Depth Variable
 * @desc Variable used for bush depth. Set to 0 to use the default value.
 * @type variable
 * @default 0
 *
 * @param defaultBushDepth
 * @text Default Bush Depth
 * @desc Bush depth used when no variable is selected. Negative values use the engine default.
 * @type number
 * @min -1
 * @default -1
 *
 * @param bushOpacityVariable
 * @text Bush Opacity Variable
 * @desc Variable used for lower-body opacity. Set to 0 to use the default value.
 * @type variable
 * @default 0
 *
 * @param defaultBushOpacity
 * @text Default Bush Opacity
 * @desc Lower-body opacity used when the variable value is negative.
 * @type number
 * @min 0
 * @max 255
 * @default 128
 *
 * @param basicFloorDamageVariable
 * @text Basic Floor Damage Variable
 * @desc Variable used for basic floor damage. Set to 0 to use the default value.
 * @type variable
 * @default 0
 *
 * @param defaultFloorDamage
 * @text Default Floor Damage
 * @desc Basic floor damage used when no variable is selected. Negative values use the engine default.
 * @type number
 * @min -1
 * @default -1
 *
 * @help
 * At game initialization, each selected variable is set to -1.
 *
 * A negative bush depth or basic floor damage value uses the corresponding engine behavior. A negative bush opacity variable value uses the configured default bush opacity.
 *
 * This plugin does not provide plugin commands.
 */

(() => {
    "use strict";

    const pluginName = "ChangeConstValues";
    const parameters = PluginManager.parameters(pluginName);
    const numberParameter = (name, defaultValue) => {
        const text = parameters[name];
        const value = text === undefined || text === "" ? defaultValue : Number(text);
        return Number.isFinite(value) ? value : defaultValue;
    };
    const bushDepthVariable = numberParameter("bushDepthVariable", 0);
    const defaultBushDepth = numberParameter("defaultBushDepth", -1);
    const bushOpacityVariable = numberParameter("bushOpacityVariable", 0);
    const defaultBushOpacity = numberParameter("defaultBushOpacity", 128);
    const basicFloorDamageVariable = numberParameter("basicFloorDamageVariable", 0);
    const defaultFloorDamage = numberParameter("defaultFloorDamage", -1);

    const parameterValue = (variableId, defaultValue) => {
        return variableId !== 0 ? $gameVariables.value(variableId) : defaultValue;
    };

    const _DataManager_createGameObjects = DataManager.createGameObjects;
    DataManager.createGameObjects = function() {
        const result = _DataManager_createGameObjects.apply(this, arguments);
        const variableIds = [bushDepthVariable, bushOpacityVariable, basicFloorDamageVariable];
        for (const variableId of variableIds) {
            if (variableId !== 0) {
                $gameVariables.setValue(variableId, -1);
            }
        }
        return result;
    };

    const _Game_Map_bushDepth = Game_Map.prototype.bushDepth;
    Game_Map.prototype.bushDepth = function() {
        const value = parameterValue(bushDepthVariable, defaultBushDepth);
        return value < 0 ? _Game_Map_bushDepth.apply(this, arguments) : value;
    };

    Game_CharacterBase.prototype.bushOpacity = function() {
        const value = parameterValue(bushOpacityVariable, defaultBushOpacity);
        return value < 0 ? defaultBushOpacity : value;
    };

    const _Sprite_Character_createHalfBodySprites = Sprite_Character.prototype.createHalfBodySprites;
    Sprite_Character.prototype.createHalfBodySprites = function() {
        const result = _Sprite_Character_createHalfBodySprites.apply(this, arguments);
        this._lowerBody.opacity = this._character.bushOpacity();
        return result;
    };

    const _Sprite_Character_updateHalfBodySprites = Sprite_Character.prototype.updateHalfBodySprites;
    Sprite_Character.prototype.updateHalfBodySprites = function() {
        const result = _Sprite_Character_updateHalfBodySprites.apply(this, arguments);
        if (this._bushDepth > 0) {
            this._lowerBody.opacity = this._character.bushOpacity();
        }
        return result;
    };

    const _Game_Actor_basicFloorDamage = Game_Actor.prototype.basicFloorDamage;
    Game_Actor.prototype.basicFloorDamage = function() {
        const value = parameterValue(basicFloorDamageVariable, defaultFloorDamage);
        return value < 0 ? _Game_Actor_basicFloorDamage.apply(this, arguments) : value;
    };
})();

```
