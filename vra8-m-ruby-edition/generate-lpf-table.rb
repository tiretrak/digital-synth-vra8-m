# refs http://www.musicdsp.org/files/Audio-EQ-Cookbook.txt
# Cookbook formulae for audio EQ biquad filter coefficients
# by Robert Bristow-Johnson

require './common'

$file = File::open("lpf-table.rb", "w")

def generate_lpf_table(name, q)
  $file.printf("$lpf_table_%s = [\n  ", name)
  (0..127).each do |i|
    f0_over_fs = (2.0 ** (i / (128.0 / 8.0))) / (2.0 ** 8.0)
    f0_over_fs = (2.0 ** (96 / (128.0 / 8.0))) / (2.0 ** 8.0) if i > 96

    w0 = 2.0 * Math::PI * f0_over_fs
    alpha = Math::sin(w0) / (2.0 * q)

    b2 = (1.0 - Math::cos(w0)) / 2.0
    a0 = 1.0 + alpha
    a1 = (-2.0) * Math::cos(w0)
    a2 = 1.0 - alpha

    b2_over_a0   = ((b2 / a0) * LPF_TABLE_ONE).round.to_i
    a1_over_a0_i = ((a1 / a0) * -LPF_TABLE_ONE).round.to_i
    a2_over_a0   = (b2_over_a0 * 4) + a1_over_a0_i - LPF_TABLE_ONE

    $file.printf("%5d, %5d, %5d,", b2_over_a0, a1_over_a0_i, a2_over_a0)
    if i == 127
      $file.printf("\n")
    elsif i % 4 == 3
      $file.printf("\n  ")
    else
      $file.printf(" ")
    end
  end
  $file.printf("]\n\n")
end

generate_lpf_table("q_1_over_sqrt_2", 1.0 / Math::sqrt(2.0))
generate_lpf_table("q_2_sqrt_2", 2.0 * Math::sqrt(2.0))

$file.close