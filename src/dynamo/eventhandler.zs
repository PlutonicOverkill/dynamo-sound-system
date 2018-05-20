// all singleplayer for now, because idk how
// to get this to run just for a single client
class DyanmoEventHandler : EventHandler {
    override void OnRegister()
    {

    }

    override void OnUnregister()
    {

    }

    override void PlayerEntered(PlayerEvent e)
    {
        let p = players[e.PlayerNumber].mo;

        if (p)
        {
            // do stuff
        }
    }

    override void PlayerDisconnected(PlayerEvent e)
    {

    }

    override void WorldTick()
    {

    }
}
