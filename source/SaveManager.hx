package;

import SaveData.SaveFileData;
import flixel.util.FlxSave;

class SaveManager {
    public static var saves:Array<FlxSave> = [];
    public static var currentSlot:Int = -1;

    public static function init():Void {
        for (i in 0...3) {
            var save = new FlxSave();
            save.bind("saveSlot" + i);
            saves.push(save);
        }
    }

    public static function getData(slot:Int):SaveFileData {
        var save = saves[slot];
        if (save.data == null) {
            return {level: 1, score: 0, playTime: 0, exists: false};
        }
        var d = save.data;
        return {
            level: (d.level != null) ? d.level : 1,
            score: (d.score != null) ? d.score : 0,
            playTime: (d.playTime != null) ? d.playTime : 0,
            exists: (d.exists != null) ? d.exists : true
        };
    }

    public static function save(slot:Int, data:SaveFileData):Void {
        data.exists = true;
        saves[slot].data.level = data.level;
        saves[slot].data.score = data.score;
        saves[slot].data.playTime = data.playTime;
        saves[slot].data.exists = data.exists;
        saves[slot].flush();
    }

    public static function deleteSlot(slot:Int):Void {
        saves[slot].erase();
    }

    public static function slotExists(slot:Int):Bool {
        return saves[slot].data != null && saves[slot].data.exists == true;
    }
}