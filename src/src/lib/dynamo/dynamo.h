#ifndef DYNAMO_SOUND_SYSTEM_DYNAMO_H
#define DYNAMO_SOUND_SYSTEM_DYNAMO_H

#include <stddef.h>
#include <stdfix.h>
#include <stdbool.h>

typedef int DSS_Tid;

typedef int DSS_Bar;
typedef int DSS_Tic;

typedef struct DSS_Channel DSS_Channel;
typedef struct DSS_Sound DSS_Sound;
typedef struct DSS_Track DSS_Track;
typedef struct DSS_Song DSS_Song;

struct DSS_Channel {
    DSS_Tid tid;
    int channel;
    fixed volume;
    fixed attenuation;
};

struct DSS_Sound {
    const DSS_Channel* channel;
    const char* name;
};

struct DSS_Track {
    DSS_Sound* sounds;
    size_t sound_count;

    const DSS_Track** next_tracks;
    size_t next_track_count;

    DSS_Bar length;

    bool is_fill;
};

struct DSS_Song {
    DSS_Track** tracks;
    size_t track_count;

    const DSS_Track* start_track;

    fixed bpm;
    DSS_Bar bar_grouping;
};

// This sets the currently playing song.
// It's a good idea to wait a bit before
// calling DSS_play_song(), as this
// functions caches all the sound files
// used in the song to prevent loading
// times when a new file plays.
//
// DSS does NOT take ownership of the
// Song, so make sure it is cleaned up
// afterwards somehow, and that it is
// not deleted before the song has
// finished playing.
void DSS_set_song(const DSS_Song*);

// Starts playing the song from the first
// track.
void DSS_play_song(void);

// Stops playing the song. Make sure that
// the song has progressed to a silent section
// via a fadeout or whatever, or the abrupt
// ending of the song will sound unnatural.
void DSS_stop_song(void);

// Restarts playback from where stop_song()
// left off.
void DSS_resume_song(void);

// Now this is where the real purpose of
// this library comes in. Whenever an action
// happens (the player comes across enemies,
// or picks up an item, or whatever) this
// function should be called, and the song
// will smoothly progress to the chosen track.
// Of course, if you haven't set up the pathways
// between tracks correctly, this function will
// have no effect.
void DSS_change_track(const DSS_Track*);

// Works the same way as DSS_change_track(),
// except once the chosen track has been played,
// the song will progress back to where it was
// before the function was called, as long as
// a pathway leads back there. Used for stingers,
// reveal music, and the like.
void DSS_change_track_once(const DSS_Track*);

// Creates a new 2d audio channel.
DSS_Channel* DSS_new_channel_2d();

// Creates a new 3d audio channel at the specified
// position.
DSS_Channel* DSS_new_channel_3d_position
    (fixed x, fixed y, fixed z);

// Creates a new 3d audio channel at the position
// of the specified Thing. The audio channel will
// move as the Thing moves so you can attach it
// to enemies, players, etc.
DSS_Channel* DSS_new_channel_3d(DSS_Tid);

// Deletes a channel created by one of the
// new channel functions.
void DSS_delete_chanel(DSS_Channel*);

// Changes the volume of a channel.
void DSS_set_channel_volume(DSS_Channel*, fixed);

#endif
