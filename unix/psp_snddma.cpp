/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.
Copyright (C) 2007 Quake1 Peter Mackay and Chris Swindle.
Copyright (C) 2009 Quake3 Crow_bar.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Foobar; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/

// snddma_null.c
// all other sound mixing is portable

#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>

#include <pspkernel.h>
#include <pspaudiolib.h>

extern "C"
{
 #include "../game/q_shared.h"
 #include "../client/snd_local.h"
}

cvar_t *sndbits;
cvar_t *sndspeed;
cvar_t *sndchannels;

int snd_inited = 0;
int cvarinit = 0;

namespace quake3
{
	namespace sound
	{
		struct Sample
		{
			short left;
			short right;
		};

		static const unsigned int	channelCount				= 2;
		static const unsigned int	inputBufferSize				= 16384;
		static const unsigned int	inputFrequency				= 22050;
		static const unsigned int	outputFrequency				= 44100;
		static const unsigned int	inputSamplesPerOutputSample	= outputFrequency / inputFrequency;
		static Sample		inputBuffer[inputBufferSize];
		static volatile unsigned int	samplesRead;

		static inline void copySamples(const Sample* first, const Sample* last, Sample* destination)
		{
			switch (inputSamplesPerOutputSample)
			{
			case 1:
				memcpy(destination, first, (last - first) * sizeof(Sample));
				break;

			case 2:
				for (const Sample* source = first; source != last; ++source)
				{
					const Sample sample = *source;
					*destination++ = sample;
					*destination++ = sample;
				}
				break;

			case 4:
				for (const Sample* source = first; source != last; ++source)
				{
					const Sample sample = *source;
					*destination++ = sample;
					*destination++ = sample;
					*destination++ = sample;
					*destination++ = sample;
				}
				break;

			default:
				break;
			}
		}

		static void fillOutputBuffer(void* buffer, unsigned int samplesToWrite, void* userData)
		{
			// Where are we writing to?
			Sample* const destination = static_cast<Sample*> (buffer);

			// Where are we reading from?
			const Sample* const firstSampleToRead = &inputBuffer[samplesRead];

			// How many samples to read?
			const unsigned int samplesToRead = samplesToWrite / inputSamplesPerOutputSample;

			// Going to wrap past the end of the input buffer?
			const unsigned int samplesBeforeEndOfInput = inputBufferSize - samplesRead;
			if (samplesToRead > samplesBeforeEndOfInput)
			{
				// Yes, so write the first chunk from the end of the input buffer.
				copySamples(
					firstSampleToRead,
					firstSampleToRead + samplesBeforeEndOfInput,
					&destination[0]);

				// Write the second chunk from the start of the input buffer.
				const unsigned int samplesToReadFromBeginning = samplesToRead - samplesBeforeEndOfInput;
				copySamples(
					&inputBuffer[0],
					&inputBuffer[samplesToReadFromBeginning],
					&destination[samplesBeforeEndOfInput * inputSamplesPerOutputSample]);
			}
			else
			{
				// No wrapping, just copy.
				copySamples(
					firstSampleToRead,
					firstSampleToRead + samplesToRead,
					&destination[0]);
			}

			// Update the read offset.
			samplesRead = (samplesRead + samplesToRead) % inputBufferSize;
		}
	}
}

using namespace quake3;
using namespace quake3::sound;


qboolean SNDDMA_Init(void)
{
    if(snd_inited)
	  return qtrue;

	if(!cvarinit)
    {
      sndbits        = Cvar_Get("sndbits", "16", CVAR_ARCHIVE);
	  sndspeed       = Cvar_Get("sndspeed", "0", CVAR_ARCHIVE);
	  sndchannels    = Cvar_Get("sndchannels", "2", CVAR_ARCHIVE);
      cvarinit       = 1;
    }
/*
	int tmp = sndbits->integer;
    if ((tmp != 16) && (tmp != 8))
		tmp = 16;
    inputBufferSize = tmp * 1024;

	inputFrequency = sndspeed->integer;
	if(!inputFrequency)
        inputFrequency = 22050;

    channelCount = sndchannels->integer;
	if(!channelCount)
        channelCount = 2;

    inputSamplesPerOutputSample	= outputFrequency / inputFrequency;
	inputBuffer = (Sample*)memalign(16, inputBufferSize);
*/
	if(!inputBuffer)
	  Sys_Error("Audio Init Error: no memory");

	// Set up Quake's audio.
	dma.channels = channelCount;

	if (dma.channels < 1 || dma.channels > 2)
		dma.channels = 2;

    dma.samplebits = inputBufferSize/1024 /*(int)sndbits->value*/;

	dma.speed				= inputFrequency;
	dma.samples			    = inputBufferSize * channelCount;
	dma.submission_chunk	= 1;
	dma.buffer				= (unsigned char *) inputBuffer;

	// Initialise the audio system. This initialises it for the CD audio module
	// too.
	pspAudioInit();

	// Set the channel callback.
	// Sound effects use channel 0, CD audio uses channel 1.
	pspAudioSetChannelCallback(0, fillOutputBuffer, 0);

    snd_inited = 1;

	return qtrue;
}

int	SNDDMA_GetDMAPos(void)
{
    if (!snd_inited)
	    return 0;
    
	return samplesRead * channelCount;
}

void SNDDMA_Shutdown(void)
{
    if(!snd_inited)
	  return;

	// Clear the mixing buffer so we don't get any noise during cleanup.
	memset(inputBuffer, 0, sizeof(inputBuffer));
/*
	free(inputBuffer);
	inputBuffer = NULL;
*/
	// Clear the channel callback.
	pspAudioSetChannelCallback(0, 0, 0);

	// Stop the audio system?
	pspAudioEndPre();

	// Insert a false delay so the thread can be cleaned up.
	sceKernelDelayThread(50 * 1000);

	// Shut down the audio system.
	pspAudioEnd();

	snd_inited = 0;
}

void SNDDMA_BeginPainting (void)
{
}

void SNDDMA_Submit(void)
{
}
