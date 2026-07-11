
```javascript
//=============================================================================
// GainMessage.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc Shows a message when event commands change gold, items, weapons, or armors.
 * @author taroxd
 *
 * @param itemFormat
 * @text Item Format
 * @desc Message format for items, weapons, and armors. Supports \action, \value, \icon, \name, and regular Show Text escape codes.
 * @type string
 * @default \action \icon\name * \value
 *
 * @param goldFormat
 * @text Gold Format
 * @desc Message format for gold. Supports \action, \value, \icon, \name, and regular Show Text escape codes.
 * @type string
 * @default \action \icon\value \name
 *
 * @param actionGain
 * @text Gain Action
 * @desc Text used by \action when the party gains something.
 * @type string
 * @default Got
 *
 * @param actionLose
 * @text Lose Action
 * @desc Text used by \action when the party loses something.
 * @type string
 * @default Lost
 *
 * @param goldIconIndex
 * @text Gold Icon Index
 * @desc Icon index used by \icon for gold. Negative values make \icon empty.
 * @type number
 * @min -1
 * @default 160
 *
 * @param background
 * @text Message Background
 * @desc Background type used by gain/loss messages.
 * @type select
 * @option Window
 * @value 0
 * @option Dim
 * @value 1
 * @option Transparent
 * @value 2
 * @default 1
 *
 * @param position
 * @text Message Position
 * @desc Position used by gain/loss messages.
 * @type select
 * @option Top
 * @value 0
 * @option Middle
 * @value 1
 * @option Bottom
 * @value 2
 * @default 1
 *
 * @param gainGoldSe
 * @text Gain Gold SE
 * @desc SE played when gaining gold. Leave blank to disable.
 * @type file
 * @dir audio/se/
 * @default Coin
 *
 * @param loseGoldSe
 * @text Lose Gold SE
 * @desc SE played when losing gold. Leave blank to disable.
 * @type file
 * @dir audio/se/
 * @default Blow2
 *
 * @param gainItemSe
 * @text Gain Item SE
 * @desc SE played when gaining an item, weapon, or armor. Leave blank to disable.
 * @type file
 * @dir audio/se/
 * @default Item1
 *
 * @param loseItemSe
 * @text Lose Item SE
 * @desc SE played when losing an item, weapon, or armor. Leave blank to disable.
 * @type file
 * @dir audio/se/
 * @default Blow2
 *
 * @param seVolume
 * @text SE Volume
 * @desc Volume used for configured sound effects.
 * @type number
 * @min 0
 * @max 100
 * @default 90
 *
 * @param sePitch
 * @text SE Pitch
 * @desc Pitch used for configured sound effects.
 * @type number
 * @min 50
 * @max 150
 * @default 100
 *
 * @param sePan
 * @text SE Pan
 * @desc Pan used for configured sound effects.
 * @type number
 * @min -100
 * @max 100
 * @default 0
 *
 * @command off
 * @text Suppress Messages
 * @desc Suppresses the next count gain/loss messages. This counter is not saved.
 *
 * @arg count
 * @text Count
 * @desc Number of upcoming gain/loss messages to suppress.
 * @type number
 * @min 1
 * @default 1
 *
 * @help
 * This plugin shows a message when these event commands change the party's
 * inventory:
 *   Change Gold
 *   Change Items
 *   Change Weapons
 *   Change Armors
 *
 * RPG Maker MZ does not show such messages by default; the default commands
 * only update party data.
 *
 * Message format escape codes:
 *   \name    Item name or currency unit.
 *   \value   Actual changed amount after inventory limits are applied.
 *   \icon    Item icon or configured gold icon.
 *   \action  Gain Action or Lose Action.
 *
 * Regular Show Text escape codes are also supported.
 *
 * Plugin command:
 *   Suppress Messages
 *     count: suppresses the next count gain/loss messages.
 *
 * For compatibility with old-style plugin commands, this plugin also accepts:
 *   GainMessage off
 *   GainMessage off 3
 *
 * The suppression counter is kept only in memory. It is reset on new game and
 * after loading a save file.
 */

(() => {
    "use strict";

    const pluginName = "GainMessage";
    const parameters = PluginManager.parameters(pluginName);

    const stringParameter = (name, defaultValue) => {
        const text = parameters[name];
        return text === undefined ? defaultValue : text;
    };

    const numberParameter = (name, defaultValue) => {
        const text = parameters[name];
        const value = text === undefined || text === "" ? defaultValue : Number(text);
        return Number.isFinite(value) ? value : defaultValue;
    };

    const itemFormat = stringParameter("itemFormat", "\\action \\icon\\name * \\value");
    const goldFormat = stringParameter("goldFormat", "\\action \\icon\\value \\name");
    const actionGain = stringParameter("actionGain", "Got");
    const actionLose = stringParameter("actionLose", "Lost");
    const goldIconIndex = numberParameter("goldIconIndex", 160);
    const background = numberParameter("background", 1);
    const position = numberParameter("position", 1);
    const gainGoldSe = stringParameter("gainGoldSe", "Coin");
    const loseGoldSe = stringParameter("loseGoldSe", "Blow2");
    const gainItemSe = stringParameter("gainItemSe", "Item1");
    const loseItemSe = stringParameter("loseItemSe", "Blow2");
    const seVolume = numberParameter("seVolume", 90);
    const sePitch = numberParameter("sePitch", 100);
    const sePan = numberParameter("sePan", 0);

    let suppressCount = 0;

    const resetSuppressCount = () => {
        suppressCount = 0;
    };

    const normalizedCount = value => {
        const count = Number(value === undefined || value === "" ? 1 : value);
        return Number.isFinite(count) ? Math.max(Math.floor(count), 0) : 1;
    };

    const suppressMessages = count => {
        suppressCount += normalizedCount(count);
    };

    const isEquipmentItem = item => {
        return DataManager.isWeapon(item) || DataManager.isArmor(item);
    };

    const numItemsWithEquip = (item, includeEquip) => {
        let count = $gameParty.numItems(item);
        if (includeEquip && isEquipmentItem(item)) {
            for (const actor of $gameParty.members()) {
                count += actor.equips().filter(equip => equip === item).length;
            }
        }
        return count;
    };

    const iconText = iconIndex => {
        return iconIndex >= 0 ? "\\I[" + iconIndex + "]" : "";
    };

    const makeMessage = (value, item) => {
        const format = item ? itemFormat : goldFormat;
        const replacements = {
            "\\action": value > 0 ? actionGain : actionLose,
            "\\value": String(Math.abs(value)),
            "\\icon": item ? iconText(item.iconIndex) : iconText(goldIconIndex),
            "\\name": item ? item.name : TextManager.currencyUnit
        };
        return format.replace(/\\(?:action|value|icon|name)/gi, match => {
            return replacements[match.toLowerCase()] || match;
        });
    };

    const playSe = (value, item) => {
        const name = item ? (value > 0 ? gainItemSe : loseItemSe) : (value > 0 ? gainGoldSe : loseGoldSe);
        if (name) {
            AudioManager.playSe({
                name: name,
                volume: seVolume,
                pitch: sePitch,
                pan: sePan
            });
        }
    };

    const shouldSuppressMessage = () => {
        if (suppressCount > 0) {
            suppressCount--;
            return true;
        }
        return false;
    };

    const showMessage = (interpreter, value, item) => {
        if (value === 0 || shouldSuppressMessage()) {
            return;
        }
        $gameMessage.setBackground(background);
        $gameMessage.setPositionType(position);
        $gameMessage.add(makeMessage(value, item));
        playSe(value, item);
        interpreter.setWaitMode("message");
    };

    const canStartMessage = () => {
        return suppressCount > 0 || !$gameMessage.isBusy();
    };

    PluginManager.registerCommand(pluginName, "off", args => {
        suppressMessages(args.count);
    });

    const _DataManager_createGameObjects = DataManager.createGameObjects;
    DataManager.createGameObjects = function() {
        const result = _DataManager_createGameObjects.apply(this, arguments);
        resetSuppressCount();
        return result;
    };

    const _DataManager_extractSaveContents = DataManager.extractSaveContents;
    DataManager.extractSaveContents = function(contents) {
        const result = _DataManager_extractSaveContents.apply(this, arguments);
        resetSuppressCount();
        return result;
    };

    const _Game_Interpreter_pluginCommand = Game_Interpreter.prototype.pluginCommand;
    Game_Interpreter.prototype.pluginCommand = function(command, args) {
        const result = _Game_Interpreter_pluginCommand.apply(this, arguments);
        if (String(command).toLowerCase() === pluginName.toLowerCase()) {
            const subCommand = String(args[0] || "").toLowerCase();
            if (subCommand === "off") {
                const legacyCount = String(args[1] || "").toLowerCase() === "count" ? args[2] : args[1];
                suppressMessages(legacyCount);
            }
        }
        return result;
    };

    const _Game_Interpreter_command125 = Game_Interpreter.prototype.command125;
    Game_Interpreter.prototype.command125 = function(params) {
        if (!canStartMessage()) {
            return false;
        }
        const lastGold = $gameParty.gold();
        const result = _Game_Interpreter_command125.apply(this, arguments);
        showMessage(this, $gameParty.gold() - lastGold, null);
        return result;
    };

    const _Game_Interpreter_command126 = Game_Interpreter.prototype.command126;
    Game_Interpreter.prototype.command126 = function(params) {
        if (!canStartMessage()) {
            return false;
        }
        const item = $dataItems[params[0]];
        const lastNumber = numItemsWithEquip(item, false);
        const result = _Game_Interpreter_command126.apply(this, arguments);
        showMessage(this, numItemsWithEquip(item, false) - lastNumber, item);
        return result;
    };

    const _Game_Interpreter_command127 = Game_Interpreter.prototype.command127;
    Game_Interpreter.prototype.command127 = function(params) {
        if (!canStartMessage()) {
            return false;
        }
        const item = $dataWeapons[params[0]];
        const includeEquip = params[4];
        const lastNumber = numItemsWithEquip(item, includeEquip);
        const result = _Game_Interpreter_command127.apply(this, arguments);
        showMessage(this, numItemsWithEquip(item, includeEquip) - lastNumber, item);
        return result;
    };

    const _Game_Interpreter_command128 = Game_Interpreter.prototype.command128;
    Game_Interpreter.prototype.command128 = function(params) {
        if (!canStartMessage()) {
            return false;
        }
        const item = $dataArmors[params[0]];
        const includeEquip = params[4];
        const lastNumber = numItemsWithEquip(item, includeEquip);
        const result = _Game_Interpreter_command128.apply(this, arguments);
        showMessage(this, numItemsWithEquip(item, includeEquip) - lastNumber, item);
        return result;
    };
})();

```
