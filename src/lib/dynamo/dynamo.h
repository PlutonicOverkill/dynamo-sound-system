#ifndef DYNAMO_SOUND_SYSTEM_DYNAMO_H
#define DYNAMO_SOUND_SYSTEM_DYNAMO_H

#include <stdbool.h>

typedef int DSS_Bar;
typedef int DSS_Tic;

typedef struct {
    char* file_name;
} DSS_Sound;

typedef struct {
    
} DSS_Channel;

typedef struct {
    DSS_Channel channels[];
    size_t channel_count;
    
    DSS_Track* next_tracks[];
    size_t next_track_count;
    
    DSS_Bar length;
    
    bool is_fill;
} DSS_Track;

// Note: Make sure the pointer members
// in the Song do not point to local
// variables, or DSS will be accessing
// dangling memory!
typedef struct {
    DSS_Track* tracks[];
    size_t track_count;
    
    DSS_Track* start_track;
    
    fixed bpm;
} DSS_Song;

// Sets up the library.
// Should be called once at the 
// start of every map.
void DSS_init(void);

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
void DSS_set_song(DSS_Song*);

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
void DSS_change_track(DSS_Track*);

// Works the same way as DSS_change_track(),
// except once the chosen track has been played,
// the song will progress back to where it was
// before the function was called, as long as
// a pathway leads back there. Used for stingers,
// reveal music, and the like.
void DSS_change_track_once(DSS_Track*);

#endif
