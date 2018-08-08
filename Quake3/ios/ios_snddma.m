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
#include "../renderergl1/tr_local.h"

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
static OSStatus S_Callback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp,
                           UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
	if ((*ioActionFlags & (kAudioUnitRenderAction_PreRender | kAudioUnitRenderAction_PostRender)) == 0) {
		UInt32 offset = (s_chunkCount * s_submissionChunk + s_offsetWithinChunk) & (s_maxMixedSamples - 1);
        
		bcopy(s_mixedSamples + offset, ioData->mBuffers[0].mData, inNumberFrames * sizeof(*s_mixedSamples) * 2);
		s_offsetWithinChunk += inNumberFrames * 2;
		if (s_offsetWithinChunk >= s_submissionChunk) {
			++s_chunkCount;
			s_offsetWithinChunk &= (s_submissionChunk - 1);
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
    
	chunkSize = ri.Cvar_Get("s_chunksize", "2048", CVAR_ARCHIVE);
	bufferSize = ri.Cvar_Get("s_buffersize", "16384", CVAR_ARCHIVE);
    
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
        NSLog(@"%@", error);
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
    
	if ((result = AudioUnitSetProperty(s_outputAudioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0,
	                                   &outputFormat, sizeof(outputFormat))) != noErr) {
		ri.Printf(PRINT_ERROR, "Could not set output audio format, result=%d\n", result);
		return qfalse;
	}
    
	s_submissionChunk = chunkSize->integer;
	s_maxMixedSamples = bufferSize->integer;
	maxFramesPerSlice = s_submissionChunk / 2;
    
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
