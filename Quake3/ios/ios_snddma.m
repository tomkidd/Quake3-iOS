/*
 * Quake3 -- iOS Port
 *
 * Seth Kingsley, July 2011.
 */

#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioServices.h>
#include <AudioToolbox/AudioComponent.h>
#include <AudioToolbox/AUComponent.h>
#include <AudioToolbox/AudioUnitProperties.h>
#include <AudioToolbox/AudioOutputUnit.h>

// For 'ri'
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
#include "../renderergl1/tr_local.h"
#pragma clang diagnostic pop

#include "../client/client.h"
#include "../client/snd_local.h"

static UInt32 s_submissionChunk;
static UInt32 s_maxMixedSamples;
static AudioUnit s_outputAudioUnit;
static SInt16 *s_mixedSamples;
static UInt32 s_chunkCount;     // number of chunks submitted
static UInt32 s_offsetWithinChunk;

/*
 ===============
 S_Callback
 ===============
 */
static OSStatus S_Callback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
    
//    Com_Printf ("********* S_Callback *********\n");
//    Com_Printf ("S_Callback s_chunkCount: %i\n", s_chunkCount);
//    Com_Printf ("S_Callback inNumberFrames: %i\n", inNumberFrames);
//    Com_Printf ("S_Callback s_submissionChunk: %i\n", s_submissionChunk);
//    Com_Printf ("S_Callback s_offsetWithinChunk: %i\n", s_offsetWithinChunk);
//    Com_Printf ("S_Callback s_maxMixedSamples: %i\n", s_maxMixedSamples);

    if ((*ioActionFlags & (kAudioUnitRenderAction_PreRender | kAudioUnitRenderAction_PostRender)) == 0) {
		UInt32 offset = (s_chunkCount * s_submissionChunk + s_offsetWithinChunk) & (s_maxMixedSamples - 1);
        
//        Com_Printf ("S_Callback 2 offset: %i\n", offset);
        
//        Com_Printf ("S_Callback inNumberFrames * sizeof(*s_mixedSamples) * 2: %lu\n", inNumberFrames * sizeof(*s_mixedSamples) * 2);
        
//        Com_Printf ("S_Callback offset + inNumberFrames * sizeof(*s_mixedSamples) * 2: %lu\n", offset + (inNumberFrames * sizeof(*s_mixedSamples) * 2));
        
        if ((offset + (inNumberFrames * 2)) > s_maxMixedSamples) {
            
            UInt32 s_offsetWithinChunk = (offset + (inNumberFrames * 2)) - s_maxMixedSamples;
            
//            Com_Printf ("S_Callback %i ***CLICK*** (%i over)\n", s_chunkCount, s_offsetWithinChunk);

            bcopy(s_mixedSamples + offset, ioData->mBuffers[0].mData, s_offsetWithinChunk * sizeof(*s_mixedSamples));

            bcopy(s_mixedSamples + 0, ioData->mBuffers[0].mData, (s_offsetWithinChunk - (inNumberFrames / 2)) * sizeof(*s_mixedSamples) * 2);

            ++s_chunkCount;
        } else {
            bcopy(s_mixedSamples + offset, ioData->mBuffers[0].mData, inNumberFrames * sizeof(*s_mixedSamples) * 2);

            s_offsetWithinChunk += inNumberFrames * 2;
        }
        
//        Com_Printf ("S_Callback *NEW* s_offsetWithinChunk: %i\n", s_offsetWithinChunk);
        
		if (s_offsetWithinChunk >= s_submissionChunk) {
			++s_chunkCount;
//            s_offsetWithinChunk &= (s_submissionChunk - 1);
            s_offsetWithinChunk = 0;
            
//            Com_Printf ("S_Callback *NEW* *NEW* s_offsetWithinChunk: %i\n", s_offsetWithinChunk);
		}
	}
    
	return noErr;
}

/*
 ===============
 S_MakeTestPattern
 ===============
 */
//static void S_MakeTestPattern(void) {
//	int i;
//	float v;
//	int sample;
//	double freq1 = s_maxMixedSamples / 1000.0;
//
//	for (i = 0; i < dma.samples / 2; i++) {
//		v = sin(M_PI * 2 * i / freq1);
//		sample = v * 0x4000;
//		((short *)dma.buffer)[i * 2] = sample;
//		((short *)dma.buffer)[i * 2 + 1] = sample;
//	}
//}

/*
 ===============
 SNDDMA_Init
 ===============
 */
qboolean SNDDMA_Init(void) {
	cvar_t *bufferSize;
	cvar_t *chunkSize;
	OSStatus result;
	AudioComponentDescription outputDesc = {
		kAudioUnitType_Output,
		kAudioUnitSubType_RemoteIO,
		kAudioUnitManufacturer_Apple,
		0,
		0
	};
	AudioComponent outputComponent;
	AudioStreamBasicDescription outputFormat;
	UInt32 maxFramesPerSlice;
	AURenderCallbackStruct renderCallback = { &S_Callback, NULL };
    
	s_outputAudioUnit = NULL;
	s_mixedSamples = NULL;
    
//    chunkSize = ri.Cvar_Get("s_chunksize", "2048", CVAR_ARCHIVE);
//    bufferSize = ri.Cvar_Get("s_buffersize", "16384", CVAR_ARCHIVE);
    
    chunkSize = ri.Cvar_Get("s_chunksize", "4096", CVAR_ARCHIVE);
    bufferSize = ri.Cvar_Get("s_buffersize", "32768", CVAR_ARCHIVE);
    
	if (!chunkSize->integer) {
		ri.Error(ERR_FATAL, "snd_chunkSize must be non-zero\n");
	}
    
	if (!bufferSize->integer) {
		ri.Error(ERR_FATAL, "snd_bufferSize must be non-zero\n");
	}
    
	if (chunkSize->integer >= bufferSize->integer) {
		ri.Error(ERR_FATAL, "snd_chunkSize must be less than snd_bufferSize\n");
	}
    
	if (bufferSize->integer % chunkSize->integer) {
		ri.Error(ERR_FATAL, "snd_bufferSize must be an even multiple of snd_chunkSize\n");
	}
    
//    if ((result = AudioSessionInitialize(NULL, NULL, NULL, NULL)) != noErr) {
//        ri.Printf(PRINT_ERROR, "Could not initialize audio session, result=%d\n", result);
//        return qfalse;
//    }
    
    NSError* error = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if( error != nil ) {
        NSLog(@"error1: %@", error);
    }
    
    [[AVAudioSession sharedInstance] setPreferredSampleRate:22050 error:&error];
    if( error != nil ) {
        NSLog(@"error2: %@", error);
    }
    
	outputComponent = AudioComponentFindNext(NULL, &outputDesc);
	if (!outputComponent) {
		ri.Printf(PRINT_ERROR, "Could not find audio output component\n");
		return qfalse;
	}
    
	if ((result = AudioComponentInstanceNew(outputComponent, &s_outputAudioUnit)) != noErr) {
		ri.Printf(PRINT_ERROR, "Could not create audio output component, result=%d\n", result);
		return qfalse;
	}
    
	outputFormat.mSampleRate = 22050;
	outputFormat.mFormatID = kAudioFormatLinearPCM;
	outputFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked;
	outputFormat.mChannelsPerFrame = 2;
	outputFormat.mBitsPerChannel = 16;
	outputFormat.mFramesPerPacket = 1;
	outputFormat.mBytesPerFrame = (outputFormat.mBitsPerChannel >> 3) * outputFormat.mChannelsPerFrame;
	outputFormat.mBytesPerPacket = outputFormat.mBytesPerFrame * outputFormat.mFramesPerPacket;
    
    Com_Printf ("SNDDMA_Init: outputFormat mSampleRate: %f\n", outputFormat.mSampleRate);
    Com_Printf ("SNDDMA_Init: outputFormat mFormatID: %i\n", outputFormat.mFormatID);
    Com_Printf ("SNDDMA_Init: outputFormat mFormatFlags: %i\n", outputFormat.mFormatFlags);
    Com_Printf ("SNDDMA_Init: outputFormat mChannelsPerFrame: %i\n", outputFormat.mChannelsPerFrame);
    Com_Printf ("SNDDMA_Init: outputFormat mBitsPerChannel: %i\n", outputFormat.mBitsPerChannel);
    Com_Printf ("SNDDMA_Init: outputFormat mFramesPerPacket: %i\n", outputFormat.mFramesPerPacket);
    Com_Printf ("SNDDMA_Init: outputFormat mBytesPerFrame: %i\n", outputFormat.mBytesPerFrame);
    Com_Printf ("SNDDMA_Init: outputFormat mBytesPerPacket: %i\n", outputFormat.mBytesPerPacket);

    
	if ((result = AudioUnitSetProperty(s_outputAudioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0,
	                                   &outputFormat, sizeof(outputFormat))) != noErr) {
		ri.Printf(PRINT_ERROR, "Could not set output audio format, result=%d\n", result);
		return qfalse;
	}
    
	s_submissionChunk = chunkSize->integer;
	s_maxMixedSamples = bufferSize->integer;
	maxFramesPerSlice = s_submissionChunk / 2;
    
    Com_Printf ("SNDDMA_Init: s_submissionChunk: %i\n", s_submissionChunk);
    Com_Printf ("SNDDMA_Init: s_maxMixedSamples: %i\n", s_maxMixedSamples);
    Com_Printf ("SNDDMA_Init: maxFramesPerSlice: %i\n", maxFramesPerSlice);

    if ((result = AudioUnitSetProperty(s_outputAudioUnit, kAudioUnitProperty_MaximumFramesPerSlice,
	                                   kAudioUnitScope_Global, 0, &maxFramesPerSlice, sizeof(maxFramesPerSlice))) != noErr) {
		ri.Printf(PRINT_ERROR, "Could not set maximum audio output chunk size, result=%d\n", result);
		return qfalse;
	}
    
	if ((result = AudioUnitSetProperty(s_outputAudioUnit, kAudioUnitProperty_SetRenderCallback,
	                                   kAudioUnitScope_Input, 0, &renderCallback, sizeof(renderCallback))) != noErr) {
		ri.Printf(PRINT_ERROR, "Could not set audio input callback, result=%d\n", result);
		return qfalse;
	}
    
	s_mixedSamples = CFAllocatorAllocate(NULL, sizeof(*s_mixedSamples) * s_maxMixedSamples, 0);
    
	dma.channels = outputFormat.mChannelsPerFrame;
	dma.samples = s_maxMixedSamples;
	dma.submission_chunk = s_submissionChunk;
	dma.samplebits = outputFormat.mBitsPerChannel;
	dma.speed = outputFormat.mSampleRate;
	dma.buffer = (byte *)s_mixedSamples;
    
	// queue up the first submission-chunk sized buffer
	s_chunkCount = s_offsetWithinChunk = 0;
    
	if ((result = AudioUnitInitialize(s_outputAudioUnit)) != noErr) {
		ri.Printf(PRINT_ERROR, "Could not initialize audio unit, result=%d\n", result);
		return qfalse;
	}
    
	if ((result = AudioOutputUnitStart(s_outputAudioUnit)) != noErr) {
		ri.Printf(PRINT_ERROR, "Could not start audio unit, result=%d\n", result);
		return qfalse;
	}
    
	return qtrue;
}

/*
 ===============
 SNDDMA_GetDMAPos
 ===============
 */
int SNDDMA_GetDMAPos(void) {
	//Com_DPrintf("SNDDMA_GetDMAPos(): %i\n", (s_chunkCount * s_submissionChunk) / 2);
	return s_chunkCount * s_submissionChunk /*+ s_offsetWithinChunk*/;
}

/*
 ===============
 SNDDMA_Trace
 ===============
 */
void SNDDMA_Trace(const char *label) {
	char buf[71];
	memset(buf, '-', 70);
	buf[70] = '\0';
	UInt32 offset = (s_chunkCount * s_submissionChunk + s_offsetWithinChunk) & (s_maxMixedSamples - 1);
	UInt32 submit = s_paintedtime & (s_maxMixedSamples - 1);
	buf[(int)(((float)offset / s_maxMixedSamples) * 70)] = '#';
	buf[(int)(((float)submit / s_maxMixedSamples) * 70)] = '*';
	Com_DPrintf("%16s [%s]\n", label, buf);
}

/*
 ===============
 SNDDMA_Shutdown
 ===============
 */
void SNDDMA_Shutdown(void) {
	if (s_outputAudioUnit) {
		AudioOutputUnitStop(s_outputAudioUnit); // Necessary?
		AudioUnitUninitialize(s_outputAudioUnit); // Necessary?
		AudioComponentInstanceDispose(s_outputAudioUnit);
//        AudioSessionSetActive(false);
        NSError* error = nil;
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
        if( error != nil ) {
            NSLog(@"%@", error);
        }

	}
    
	if (s_mixedSamples)
		CFAllocatorDeallocate(NULL, s_mixedSamples);
}

/*
 ===============
 SNDDMA_BeginPainting
 ===============
 */
void SNDDMA_BeginPainting(void) {
#if 0
	SNDDMA_Trace("BeginPainting");
#endif // 0
}

/*
 ===============
 SNDDMA_Submit
 ===============
 */
void SNDDMA_Submit(void) {
#if 0
	SNDDMA_Trace("Submit");
	S_MakeTestPattern();
#endif // 0
}
