# Digital Synth VRA8-M 0.0.0

- 2015-00-00 ISGK Instruments
- <https://github.com/risgk/digital-synth-vra8-m>

## Concept

- Monophonic Synthesizer (MIDI Sound Module) for Arduino Uno

## Features

- Sketch for Arduino Uno
- Serial MIDI In (38400 bps), PWM Audio Out (Pin 6), PWM Rate: 62500 Hz
- Sampling Rate: 15625 Hz, Bit Depth: 8 bits
- Recommending [Hairless MIDI<->Serial Bridge](http://projectgus.github.io/hairless-midiserial/) to connect PC
- Files
    - "DigitalSynthVRA8M.ino" for Arduino Uno
    - "MakeSampleWavFile.cc" for Debugging on PC, that makes a sample WAV file

## VRA8-M CTRL

- Parameter Editor (MIDI Controller) for VRA8-M, Web App
- We recommend Google Chrome, which implements Web MIDI API
- Recommending [loopMIDI](http://www.tobias-erichsen.de/software/loopmidi.html) (virtual loopback MIDI cable) to connect VRA8-M
- CAUTION: Click sounds occur sometimes when you change the controllers

## VRA8-M Ruby Edition

- Software Synthesizer for Windows, Faithful Simulator of VRA8-M
- Sampling Rate: 15625 Hz, Bit Depth: 8 bits
- Requiring Ruby (JRuby), UniMIDI, and win32-sound
    - `jgem install unimidi`
    - `jgem install win32-sound`
- Usage
    - `jruby main.rb` starts VRA8-M Ruby Edition
    - `jruby main.rb sample-midi-stream.bin` makes a sample WAV file
- Known Issues
    - VRA8-M Ruby Edition spends the full power of 2 CPU cores...

## Controllers

    +-----------------------+---------------+---------------+---------------+---------------+
    | Controller            | Value 0       | Value 64      | Value 127     | Preset Lead   |
    +-----------------------+---------------+---------------+---------------+---------------+
    | LFO Rate              | 0.48 Hz       | 8.1 Hz        | 15.5 Hz       | 0             |
    | LFO Rate EG Amt       | 0%            | 50%           | 99.2%         | 16            |
    | LFO Level EG Coef     | 0%            | 49.6%         | 100%          | 127           |
    +-----------------------+---------------+---------------+---------------+---------------+
    | VCO Color LFO Amt     | 0%            | 50%           | 99.2%         | 16            |
    | VCO Mix (Pulse/Saw)   | Pulse 100%    | Pulse 50.4%   | Pulse 0%      | 0             |
    |                       | Saw 0%        | Saw 49.6%     | Saw 100%      |               |
    | VCO Mix EG Amt        | 0%            | 50%           | 99.2%         | 64            |
    | VCO Pulse Width       | 50%           | 25%           | 0.4%          | 0             |
    | VCO Saw Shift         | 0%            | 25%           | 49.6%         | 64            |
    | VCO Portamento        | 0.0 s/Oct     | 0.13 s/Oct    | 1.0 s/Oct     | 64            |
    +-----------------------+---------------+---------------+---------------+---------------+
    | VCF Cutoff            | 0.24 kHz      | 1.4 kHz       | 7.6 kHz       | 0             |
    | VCF Cutoff EG Amt     | 0%            | 50%           | 99.2%         | 124           |
    | VCF Resonance         | Q = 0.7       | Q = 1.4       | Q = 2.8       | 64            |
    +-----------------------+---------------+---------------+---------------+---------------+
    | VCA Gain              | 0%            | 50%           | 99.2%         | 127           |
    +-----------------------+---------------+---------------+---------------+---------------+
    | EG Attack             | 4.2 ms        | 0.14 s        | 4.2 s         | 24            |
    | EG Decay/Release      | 10.0 ms       | 0.33 s        | 10.0 s        | 84            |
    | EG Sustain            | 0%            | 50%           | 99.2%         | 127           |
    +-----------------------+---------------+---------------+---------------+---------------+

## MIDI Implementation Chart

      [Monophonic Synthesizer]                                        Date: 2015-00-00       
      Model  Digital Synth VRA8-M     MIDI Implementation Chart       Version: 0.0.0         
    +-------------------------------+---------------+---------------+-----------------------+
    | Function...                   | Transmitted   | Recognized    | Remarks               |
    +-------------------------------+---------------+---------------+-----------------------+
    | Basic        Default          | x             | 1             |                       |
    | Channel      Changed          | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | Mode         Default          | x             | Mode 4 (M=1)  |                       |
    |              Messages         | x             | x             |                       |
    |              Altered          | ************* |               |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | Note                          | x             | 0-127         |                       |
    | Number       : True Voice     | ************* | 24-84         |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | Velocity     Note ON          | x             | x             |                       |
    |              Note OFF         | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | After        Key's            | x             | x             |                       |
    | Touch        Ch's             | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | Pitch Bend                    | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | Control                    16 | x             | o             | LFO Rate EG Amt       |
    | Change                     17 | x             | o             | VCO Color LFO Amt     |
    |                            18 | x             | o             | VCO Mix EG Amt        |
    |                            19 | x             | o             | VCF Cutoff EG Amt     |
    |                            20 | x             | o             | VCF Resonance         |
    |                            21 | x             | o             | EG Attack             |
    |                            22 | x             | o             | EG Decay/Release      |
    |                            23 | x             | o             | EG Sustain            |
    |                            24 | x             | o             | LFO Rate              |
    |                            25 | x             | o             | LFO Level EG Coef     |
    |                            26 | x             | o             | VCO Mix (Pulse/Saw)   |
    |                            27 | x             | o             | VCF Cutoff            |
    |                            28 | x             | o             | VCO Pulse Width       |
    |                            29 | x             | o             | VCO Saw Shift         |
    |                            30 | x             | o             | VCO Portamento        |
    |                            31 | x             | o             | VCO Gain              |
    +-------------------------------+---------------+---------------+-----------------------+
    | Program                       | x             | x             |                       |
    | Change       : True #         | ************* |               |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | System Exclusive              | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | System       : Song Pos       | x             | x             |                       |
    | Common       : Song Sel       | x             | x             |                       |
    |              : Tune           | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | System       : Clock          | x             | x             |                       |
    | Real Time    : Commands       | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | Aux          : Local ON/OFF   | x             | x             |                       |
    | Messages     : All Notes OFF  | x             | o             |                       |
    |              : Active Sense   | x             | x             |                       |
    |              : Reset          | x             | x             |                       |
    +-------------------------------+---------------+---------------+-----------------------+
    | Notes                         |                                                       |
    |                               |                                                       |
    +-------------------------------+-------------------------------------------------------+
      Mode 1: Omni On,  Poly          Mode 2: Omni On,  Mono          o: Yes                 
      Mode 3: Omni Off, Poly          Mode 4: Omni Off, Mono          x: No                  
