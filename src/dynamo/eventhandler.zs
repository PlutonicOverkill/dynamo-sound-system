// all singleplayer for now, because idk how
// to get this to run just for a single client
class DyanmoEventHandler : EventHandler {
    override void OnRegister()
    {
        // Dynamo.Init();
    }

    override void OnUnregister()
    {
        Dynamo.DeInit();
    }

    override void PlayerEntered(PlayerEvent e)
    {
        let p = players[e.PlayerNumber].mo;

        if (p)
        {
            // do stuff
        }

        Dynamo.Init(); // can't be done in OnRegister as map hasn't been loaded yet
    }

    override void WorldTick()
    {
        Dynamo.Frame();
    }
}
