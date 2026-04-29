package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SaveSlot extends FlxSpriteGroup {
    public var slotIndex:Int;
    var bg:FlxSprite;
    var titleText:FlxText;
    var infoText:FlxText;

    public function new(x:Float, y:Float, slot:Int) {
        super(x, y);
        slotIndex = slot;

        bg = new FlxSprite(0, 0);
        bg.makeGraphic(400, 80, FlxColor.GRAY);
        add(bg);

        titleText = new FlxText(10, 10, 380, "Save File " + (slot + 1), 16);
        titleText.setFormat(null, 16, FlxColor.WHITE, "left");
        add(titleText);

        infoText = new FlxText(10, 40, 380, "", 12);
        infoText.setFormat(null, 12, FlxColor.WHITE, "left");
        add(infoText);

        refresh();
    }

    public function refresh():Void {
        if (SaveManager.slotExists(slotIndex)) {
            var data = SaveManager.getData(slotIndex);
            infoText.text = "Level: " + data.level + " | Score: " + data.score + " | Time: " + Math.floor(data.playTime) + "s";
            bg.color = FlxColor.BLUE;
        } else {
            infoText.text = "New Game";
            bg.color = FlxColor.GRAY;
        }
    }

    public function select(selected:Bool):Void {
        bg.alpha = selected ? 1.0 : 0.6;
    }
}