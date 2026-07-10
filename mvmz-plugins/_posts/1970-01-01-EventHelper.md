
```javascript
//=============================================================================
// EventHelper.js
//=============================================================================

/*:
 * @target MZ
 * @plugindesc Adds convenience APIs for event scripts and movement-route scripts.
 * @author taroxd
 *
 * @command AddBattleLog
 * @text Add Battle Log
 * @desc Adds text to the battle log. Does nothing outside battle.
 *
 * @arg text
 * @text Text
 * @type multiline_string
 * @default
 *
 * @command SelfSwitch
 * @text Set Self Switch
 * @desc Sets a self switch. Map ID 0 uses the current map; Event ID 0 uses the current event.
 *
 * @arg mapId
 * @text Map ID
 * @desc 0 uses the current map.
 * @type number
 * @min 0
 * @default 0
 *
 * @arg eventId
 * @text Event ID
 * @desc 0 uses the current event.
 * @type number
 * @min 0
 * @default 0
 *
 * @arg letter
 * @text Letter
 * @type select
 * @option A
 * @option B
 * @option C
 * @option D
 * @default A
 *
 * @arg operation
 * @text Operation
 * @type select
 * @option ON
 * @value on
 * @option OFF
 * @value off
 * @default on
 *
 * @command StartShake
 * @text Start Screen Shake
 * @desc Starts screen shake. Duration 0 continues until Stop Screen Shake is called.
 *
 * @arg power
 * @text Power
 * @type number
 * @min 0
 * @default 5
 *
 * @arg speed
 * @text Speed
 * @type number
 * @min 0
 * @default 5
 *
 * @arg duration
 * @text Duration
 * @desc 0 continues until stopped.
 * @type number
 * @min 0
 * @default 0
 *
 * @command StopShake
 * @text Stop Screen Shake
 * @desc Stops the current screen shake immediately.
 *
 * @help
 * This plugin adds convenience APIs for event scripts and movement-route
 * scripts. It does not change RPG Maker MZ's script evaluators, so script
 * calls must explicitly use "this".
 *
 * Event script APIs
 *   this.thisEvent()
 *     Returns the current event, or null when it is not on the current map.
 *
 *   this.addBattleLog(text)
 *     Adds text to the battle log. Does nothing outside battle.
 *     Example: this.addBattleLog("The ground shakes.");
 *
 *   this.selfSwitch(eventId = 0, mapId = 0)
 *     Returns a self-switch reference. Event ID 0 means the current event;
 *     Map ID 0 means the current map.
 *     Examples:
 *       this.selfSwitch().a = true;
 *       this.selfSwitch(3).b = false;
 *       this.selfSwitch(3, 2).c = true;
 *
 *   this.startShake(power = 5, speed = 5, duration = 0)
 *     Starts a screen shake. Duration 0 continues until stopped.
 *     Example: this.startShake(5, 5);
 *
 *   this.stopShake()
 *     Stops screen shake immediately.
 *     Example: this.stopShake();
 *
 * Plugin commands
 *   Add Battle Log, Set Self Switch, Start Screen Shake, and Stop Screen
 *   Shake provide the same event-script features through the event editor.
 *
 * Movement-route script APIs
 * These calls are for the Script command in Set Movement Route. They also
 * require "this", which is the character whose route is running.
 *
 *   this.zoomX, this.zoomY, this.zoom
 *   this.angle, this.mirror, this.ox, this.oy
 *     Control the character sprite's scale, rotation, horizontal flip, and
 *     pivot offset.
 *     Examples:
 *       this.zoom = 1.5;
 *       this.zoomX = 2;
 *       this.angle = 45;
 *       this.mirror = true;
 *
 *   this.forcePattern(pattern)
 *     Sets the walking-character pattern to 0, 1, or 2.
 *     Example: this.forcePattern(2);
 *
 *   this.forceBushDepth(depth)
 *     Fixes bush depth to a numeric value. Pass null to restore normal bush
 *     depth behavior.
 *     Examples:
 *       this.forceBushDepth(12);
 *       this.forceBushDepth(null);
 *
 *   this.lineTo(x, y)
 *     Moves in a straight line to the map position.
 *     Example: this.lineTo(15, 12);
 *
 *   this.jumpTo(x, y)
 *     Jumps to the map position.
 *     Example: this.jumpTo(10, 8);
 *
 * Player flags
 *   $gamePlayer.waiting = true;
 *     Prevents player movement until set to false.
 *
 *   $gamePlayer.disableScroll = true;
 *     Prevents automatic map scrolling until set to false.
 */

(() => {
    "use strict";

    const pluginName = "EventHelper";

    const finiteNumber = (value, fallback) => {
        const number = Number(value);
        return Number.isFinite(number) ? number : fallback;
    };

    const selfSwitchLetter = letter => {
        const value = String(letter || "A").toUpperCase();
        return ["A", "B", "C", "D"].includes(value) ? value : "A";
    };

    function EventHelperSelfSwitch(mapId, eventId) {
        this._eventHelperMapId = mapId;
        this._eventHelperEventId = eventId;
    }

    EventHelperSelfSwitch.prototype.key = function(letter) {
        return [this._eventHelperMapId, this._eventHelperEventId, selfSwitchLetter(letter)];
    };

    EventHelperSelfSwitch.prototype.get = function(letter) {
        return $gameSelfSwitches.value(this.key(letter));
    };

    EventHelperSelfSwitch.prototype.set = function(letter, value) {
        $gameSelfSwitches.setValue(this.key(letter), !!value);
        return this;
    };

    Object.defineProperties(EventHelperSelfSwitch.prototype, {
        a: {
            get: function() {
                return this.get("A");
            },
            set: function(value) {
                this.set("A", value);
            }
        },
        b: {
            get: function() {
                return this.get("B");
            },
            set: function(value) {
                this.set("B", value);
            }
        },
        c: {
            get: function() {
                return this.get("C");
            },
            set: function(value) {
                this.set("C", value);
            }
        },
        d: {
            get: function() {
                return this.get("D");
            },
            set: function(value) {
                this.set("D", value);
            }
        }
    });

    Game_Interpreter.prototype.thisEvent = function() {
        return this.character(0);
    };

    Game_Interpreter.prototype.addBattleLog = function(text) {
        const scene = SceneManager._scene;
        if (scene instanceof Scene_Battle && scene._logWindow) {
            scene._logWindow.addText(text == null ? "" : String(text));
        }
    };

    Game_Interpreter.prototype.selfSwitch = function(eventId = 0, mapId = 0) {
        const resolvedMapId = finiteNumber(mapId, 0) > 0 ? finiteNumber(mapId, 0) : $gameMap.mapId();
        const resolvedEventId = finiteNumber(eventId, 0) > 0 ? finiteNumber(eventId, 0) : this.eventId();
        return new EventHelperSelfSwitch(resolvedMapId, resolvedEventId);
    };

    Game_Interpreter.prototype.startShake = function(power = 5, speed = 5, duration = 0) {
        const resolvedDuration = finiteNumber(duration, 0);
        $gameScreen.startShake(
            finiteNumber(power, 5),
            finiteNumber(speed, 5),
            resolvedDuration > 0 ? resolvedDuration : Infinity
        );
    };

    Game_Interpreter.prototype.stopShake = function() {
        $gameScreen.clearShake();
    };

    PluginManager.registerCommand(pluginName, "AddBattleLog", function(args) {
        this.addBattleLog(args.text);
    });

    PluginManager.registerCommand(pluginName, "SelfSwitch", function(args) {
        this.selfSwitch(args.eventId, args.mapId).set(args.letter, args.operation !== "off");
    });

    PluginManager.registerCommand(pluginName, "StartShake", function(args) {
        this.startShake(args.power, args.speed, args.duration);
    });

    PluginManager.registerCommand(pluginName, "StopShake", function() {
        this.stopShake();
    });

    const characterProperty = (field, defaultValue) => ({
        get: function() {
            return this[field] == null ? defaultValue : this[field];
        },
        set: function(value) {
            if (value == null) {
                this[field] = null;
                return;
            }
            const number = Number(value);
            this[field] = Number.isFinite(number) ? number : null;
        }
    });

    Object.defineProperties(Game_CharacterBase.prototype, {
        zoomX: characterProperty("_eventHelperZoomX", 1),
        zoomY: characterProperty("_eventHelperZoomY", 1),
        angle: characterProperty("_eventHelperAngle", 0),
        ox: characterProperty("_eventHelperOx", 0),
        oy: characterProperty("_eventHelperOy", 0),
        zoom: {
            get: function() {
                return this.zoomX;
            },
            set: function(value) {
                this.zoomX = value;
                this.zoomY = value;
            }
        },
        mirror: {
            get: function() {
                return this._eventHelperMirror == null ? false : this._eventHelperMirror;
            },
            set: function(value) {
                this._eventHelperMirror = value == null ? null : !!value;
            }
        }
    });

    Game_CharacterBase.prototype.forcePattern = function(pattern) {
        const value = Math.max(0, Math.min(2, Math.floor(finiteNumber(pattern, 1))));
        this._eventHelperForcedPattern = value;
        this._originalPattern = value;
        this.setPattern(value);
    };

    Game_CharacterBase.prototype.forceBushDepth = function(depth) {
        const value = Number(depth);
        this._eventHelperBushDepth = depth == null || depth === "" || !Number.isFinite(value) ? null : Math.max(0, value);
        this.refreshBushDepth();
    };

    Game_CharacterBase.prototype.lineTo = function(x, y) {
        const targetX = finiteNumber(x, this.x);
        const targetY = finiteNumber(y, this.y);
        const deltaX = targetX - this._realX;
        const deltaY = targetY - this._realY;
        const distance = Math.hypot(deltaX, deltaY);

        this._x = targetX;
        this._y = targetY;
        this.straighten();

        if (distance === 0) {
            this._realX = targetX;
            this._realY = targetY;
            this._eventHelperLineTo = null;
            this.refreshBushDepth();
            return;
        }

        const distancePerFrame = this.distancePerFrame();
        this._eventHelperLineTo = {
            targetX: targetX,
            targetY: targetY,
            moveX: (deltaX / distance) * distancePerFrame,
            moveY: (deltaY / distance) * distancePerFrame
        };
    };

    Game_CharacterBase.prototype.updateEventHelperLineTo = function() {
        const lineTo = this._eventHelperLineTo;
        const deltaX = lineTo.targetX - this._realX;
        const deltaY = lineTo.targetY - this._realY;
        const remainingDistance = Math.hypot(deltaX, deltaY);

        if (remainingDistance <= this.distancePerFrame()) {
            this._realX = lineTo.targetX;
            this._realY = lineTo.targetY;
            this._eventHelperLineTo = null;
            this.refreshBushDepth();
        } else {
            this._realX += lineTo.moveX;
            this._realY += lineTo.moveY;
        }
    };

    Game_CharacterBase.prototype.jumpTo = function(x, y) {
        const targetX = finiteNumber(x, this.x);
        const targetY = finiteNumber(y, this.y);
        this.jump(targetX - this.x, targetY - this.y);
    };

    const _Game_CharacterBase_updateMove = Game_CharacterBase.prototype.updateMove;
    Game_CharacterBase.prototype.updateMove = function() {
        if (this._eventHelperLineTo) {
            this.updateEventHelperLineTo();
        } else {
            _Game_CharacterBase_updateMove.apply(this, arguments);
        }
    };

    const _Game_CharacterBase_updatePattern = Game_CharacterBase.prototype.updatePattern;
    Game_CharacterBase.prototype.updatePattern = function() {
        _Game_CharacterBase_updatePattern.apply(this, arguments);
        if (this._eventHelperForcedPattern != null) {
            this.setPattern(this._eventHelperForcedPattern);
        }
    };

    const _Game_CharacterBase_refreshBushDepth = Game_CharacterBase.prototype.refreshBushDepth;
    Game_CharacterBase.prototype.refreshBushDepth = function() {
        if (this._eventHelperBushDepth != null) {
            this._bushDepth = this._eventHelperBushDepth;
        } else {
            _Game_CharacterBase_refreshBushDepth.apply(this, arguments);
        }
    };

    const _Sprite_Character_updateOther = Sprite_Character.prototype.updateOther;
    Sprite_Character.prototype.updateOther = function() {
        _Sprite_Character_updateOther.apply(this, arguments);

        const character = this._character;
        const zoomX = character._eventHelperZoomX;
        const zoomY = character._eventHelperZoomY;
        const mirror = character._eventHelperMirror;

        if (zoomX != null || mirror != null) {
            const scaleX = zoomX == null ? 1 : zoomX;
            this.scale.x = scaleX * (mirror ? -1 : 1);
        }
        if (zoomY != null) {
            this.scale.y = zoomY;
        }
        if (character._eventHelperAngle != null) {
            this.angle = character._eventHelperAngle;
        }
        if (character._eventHelperOx != null) {
            this.pivot.x = character._eventHelperOx;
        }
        if (character._eventHelperOy != null) {
            this.pivot.y = character._eventHelperOy;
        }
    };

    Object.defineProperties(Game_Player.prototype, {
        waiting: {
            get: function() {
                return !!this._eventHelperWaiting;
            },
            set: function(value) {
                this._eventHelperWaiting = !!value;
            }
        },
        disableScroll: {
            get: function() {
                return !!this._eventHelperDisableScroll;
            },
            set: function(value) {
                this._eventHelperDisableScroll = !!value;
            }
        }
    });

    const _Game_Player_canMove = Game_Player.prototype.canMove;
    Game_Player.prototype.canMove = function() {
        return !this.waiting && _Game_Player_canMove.apply(this, arguments);
    };

    const _Game_Player_updateScroll = Game_Player.prototype.updateScroll;
    Game_Player.prototype.updateScroll = function(lastScrolledX, lastScrolledY) {
        if (!this.disableScroll) {
            _Game_Player_updateScroll.apply(this, arguments);
        }
    };
})();

```
