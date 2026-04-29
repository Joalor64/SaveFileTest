package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SaveMenuState extends FlxState {
    var slots:Array<SaveSlot> = [];
    var selectedIndex:Int = 0;
    var deleteConfirm:Bool = false;
    var confirmText:FlxText;

    override public function create():Void {
        super.create();

        SaveManager.init();

        var title = new FlxText(0, 20, FlxG.width, "SELECT SAVE FILE", 24);
        title.setFormat(null, 24, FlxColor.WHITE, "center");
        add(title);

        for (i in 0...3) {
            var slot = new SaveSlot(FlxG.width / 2 - 200, 100 + i * 100, i);
            slots.push(slot);
            add(slot);
        }

        confirmText = new FlxText(0, FlxG.height - 60, FlxG.width, "", 14);
        confirmText.setFormat(null, 14, FlxColor.RED, "center");
        add(confirmText);

        var instructions = new FlxText(0, FlxG.height - 30, FlxG.width, "UP/DOWN: Select | ENTER: Play | DELETE: Erase Save", 12);
        instructions.setFormat(null, 12, FlxColor.WHITE, "center");
        add(instructions);

        updateSelection();
    }

    function updateSelection():Void {
        for (i in 0...slots.length) {
            slots[i].select(i == selectedIndex);
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP) {
            selectedIndex--;
            if (selectedIndex < 0) selectedIndex = slots.length - 1;
            updateSelection();
            cancelDelete();
        }

        if (FlxG.keys.justPressed.DOWN) {
            selectedIndex++;
            if (selectedIndex >= slots.length) selectedIndex = 0;
            updateSelection();
            cancelDelete();
        }

        if (FlxG.keys.justPressed.ENTER) {
            SaveManager.currentSlot = selectedIndex;
            FlxG.switchState(new PlayState());
        }

        if (FlxG.keys.justPressed.DELETE) {
            if (!deleteConfirm) {
                if (SaveManager.slotExists(selectedIndex)) {
                    deleteConfirm = true;
                    confirmText.text = "Press DELETE again to confirm erasing Save " + (selectedIndex + 1);
                }
            } else {
                SaveManager.deleteSlot(selectedIndex);
                slots[selectedIndex].refresh();
                cancelDelete();
                confirmText.text = "Save " + (selectedIndex + 1) + " erased.";
            }
        }
    }

    function cancelDelete():Void {
        deleteConfirm = false;
        if (confirmText.text.indexOf("Press DELETE again") != -1) {
            confirmText.text = "";
        }
    }
}