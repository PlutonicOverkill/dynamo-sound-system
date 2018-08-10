#include "../../lib/dynamo/dynamo.h"

#include <stdlib.h>
#include <stdio.h>

static DSS_Song song;

[[call("ScriptS"), script("Open")]]
void main(void)
{
    song.bpm = 95;
    song.bar_grouping = 4;

    DSS_Channel* channel = DSS_new_channel_2d();

    const size_t track_amount = 20;
    const char* track_names[track_amount] = {
        "music/test_map/a1", "music/test_map/a2", "music/test_map/a3", "music/test_map/a4",
        "music/test_map/b1", "music/test_map/b2",
        "music/test_map/c1", "music/test_map/c2",
        "music/test_map/d1", "music/test_map/d2",
        "music/test_map/e1", "music/test_map/e2",
        "music/test_map/f1", "music/test_map/f2",
        "music/test_map/g1", "music/test_map/g2",
        "music/test_map/h1", "music/test_map/h2", "music/test_map/h3", "music/test_map/h4"
    };

    DSS_Sound* sounds = malloc(track_amount * sizeof(DSS_Sound));
    DSS_Track* tracks = malloc(track_amount * sizeof(DSS_Track));

    for (size_t i = 0; i != track_amount; ++i)
    {
        sounds[i].channel = channel;
        sounds[i].name = track_names[i];

        tracks[i].sounds = &(sounds[i]);
        tracks[i].sound_count = 1;

        // TODO: next_tracks

        tracks[i].length = 4;
        tracks[i].is_fill = false;
    }
}

[[call("ScriptS"), extern("ACS")]]
void music_switch(int track)
{
    printf("Switched to track %d\n", track);
}
