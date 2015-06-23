#pragma once

#include "common.h"

class SerialIn {
public:
  INLINE static void open() {
    UBRR0 = (1000000 / SERIAL_SPEED) - 1;
    UCSR0B = _BV(RXEN0);
  }

  INLINE static boolean available() const {
    return UCSR0A & _BV(RXC0);
  }

  INLINE static int8_t read() {
    return UDR0;
  }
};
