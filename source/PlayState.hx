package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import SaveData.SaveFileData;

class PlayState extends FlxState {
    var data:SaveFileData;
    var levelText:FlxText;
    var scoreText:FlxText;
    var timeText:FlxText;

    override public function create():Void {
        super.create();

        if (SaveManager.currentSlot >= 0 && SaveManager.slotExists(SaveManager.currentSlot)) {
            data = SaveManager.getData(SaveManager.currentSlot);
        } else {
            data = {level: 1, score: 0, playTime: 0, exists: true};
        }

        var title = new FlxText(0, 20, FlxG.width, "GAMEPLAY - Slot " + (SaveManager.currentSlot + 1), 20);
        title.setFormat(null, 20, FlxColor.WHITE, "center");
        add(title);

        levelText = new FlxText(0, 100, FlxG.width, "Level: " + data.level, 18);
        levelText.setFormat(null, 18, FlxColor.WHITE, "center");
        add(levelText);

        scoreText = new FlxText(0, 150, FlxG.width, "Score: " + data.score, 18);
        scoreText.setFormat(null, 18, FlxColor.WHITE, "center");
        add(scoreText);

        timeText = new FlxText(0, 200, FlxG.width, "Time: " + Math.floor(data.playTime) + "s", 18);
        timeText.setFormat(null, 18, FlxColor.WHITE, "center");
        add(timeText);

        var help = new FlxText(0, FlxG.height - 60, FlxG.width, "SPACE: Complete Level (+Score) | ESC: Save & Quit", 14);
        help.setFormat(null, 14, FlxColor.WHITE, "center");
        add(help);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        data.playTime += elapsed;

        if (FlxG.keys.justPressed.SPACE) {
            data.level++;
            data.score += 100;
            updateUI();
            autoSave();
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            autoSave();
            FlxG.switchState(new SaveMenuState());
        }

        timeText.text = "Time: " + Math.floor(data.playTime) + "s";
    }

    function updateUI():Void {
        levelText.text = "Level: " + data.level;
        scoreText.text = "Score: " + data.score;
    }

    function autoSave():Void {
        if (SaveManager.currentSlot >= 0) {
            SaveManager.save(SaveManager.currentSlot, data);
        }
    }
}