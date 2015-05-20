require_relative 'common'
require_relative 'freq-table'
require_relative 'wave-table'

class VCO
  def initialize
    @phase = 0
    @pulse_saw_mix = 0
    @pulse_width = (0 + 128) << 8
    @pw_lfo_amt = 0 << 1
    @saw_shift = 0 << 8
    @ss_lfo_amt = 0 << 1
  end

  def set_pulse_saw_mix(control_value)
    @pulse_saw_mix = control_value
  end

  def set_pulse_width(control_value)
    @pulse_width = (control_value + 128) << 8
  end

  def set_pw_lfo_amt(control_value)
    @pw_lfo_amt = control_value << 1
  end

  def set_saw_shift(control_value)
    @saw_shift = control_value << 8
  end

  def set_ss_lfo_amt(control_value)
    @ss_lfo_amt = control_value << 1
  end

  def clock(pitch, k_lfo)
    pitch_high = high_byte(pitch)
    pitch_low = low_byte(pitch)

    freq = mul_h16($freq_table[pitch_high], $tune_table[pitch_low >> 4])
    @phase += freq
    @phase &= (CYCLE_RESOLUTION - 1)

    saw_down   = +get_level_from_wave_table(@phase, pitch_high)
    saw_up     = -get_level_from_wave_table(
                    (@phase + @pulse_width - (k_lfo * @pw_lfo_amt)) & 0xFFFF, pitch_high)
    saw_down_2 = +get_level_from_wave_table(
                    (@phase + @saw_shift + (k_lfo * @ss_lfo_amt)) & 0xFFFF, pitch_high)
    a = saw_down * 127 + saw_up * (127 - @pulse_saw_mix) +
                         saw_down_2 * @pulse_saw_mix

    return high_sbyte(a) >> 1
  end

  def get_level_from_wave_table(phase, pitch_high)
    wave_table = $wave_tables[pitch_high]
    curr_index = high_byte(phase)
    next_index = curr_index + 0x01
    next_index &= 0xFF
    curr_data = wave_table[curr_index]
    next_data = wave_table[next_index]

    next_weight = low_byte(phase)
    if (next_weight == 0)
      level = curr_data
    else
      curr_weight = 0x100 - next_weight
      level = high_sbyte((curr_data * curr_weight) + (next_data * next_weight))
    end

    return level
  end
end
