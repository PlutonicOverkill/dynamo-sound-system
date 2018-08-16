class DynamoFlashyGimmick : DynamoBeatCallback {
    private uint8 brightness;
    private Color lightColor;
    private uint tid;
    private Array<PointLight> lights;

    // also have activate() / deactivate() in callback that
    // register / unregister it with eventhandler?

    override void Call()
    {
        brightness = 32; //255;
        lightColor = Color(255, Random(), Random(), Random()); // alpha goes first for some reason? weird

        Console.printf("Color %d %d %d", lightColor.r, lightColor.g, lightColor.b);
    }

    override void WorldTick()
    {
        if (!brightness)
            return;

        for (int i = 0; i != lights.Size(); ++i) {
            lights[i].A_SetSpecial(0, lightColor.r, lightColor.g, lightColor.b, brightness /*-=4*/+= 3);
        }
    }

    static DynamoFlashyGimmick Create(uint tid)
    {
        let g = New("DynamoFlashyGimmick");

        g.brightness = 0;
        g.tid = tid;
        g.lightColor = Color(0, 0, 0, 255);

        let iterator = ActorIterator.Create(tid, "PointLight");

        PointLight light;
        while (light = PointLight(iterator.Next())) {
            g.lights.Push(light);
        }

        return g;
    }
}