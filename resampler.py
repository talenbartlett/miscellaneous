#resampler for source games using the new voice codec
#reads wav files sampled at 11025 Hz
#and converts them to the sample rate for the new codec, 22050 Hz

import wave
import os
import os.path
import itertools

for dirpath, _, files in os.walk("."):
    for f in files:
        if os.path.splitext(f)[1] == ".wav":
            with wave.open(os.path.join(dirpath, f), mode='rb') as wave_in:
                in_params = wave_in.getparams()
                if wave_in.getframerate() == 11025:
                    with wave.open(os.path.join(dirpath, "resampled_"+f), mode='wb') as wave_out:
                        wave_out.setparams(in_params[:2] + (22050,) + in_params[3:]) 
                        in_samples = wave_in.readframes(wave_in.getnframes())
                        wave_out.writeframes(bytes([s for s in in_samples for _ in range(2)]))
        
