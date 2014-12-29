# Arduino Make file. Refer to https://github.com/sudar/Arduino-Makefile

# Tested and working with a linuxspi programmer on a remote Raspberry Pi
# Refer to https://github.com/kcuzner/avrdude for linuxspi.
# Should work with ISP as well if you replace $(AVRDUDE_ARD_OPTS) with
# $(AVRDUDE_ISP_OPTS) in the net_set_fuses rule.

# Alternate core from https://code.google.com/p/arduino-tiny
ALTERNATE_CORE = tiny
BOARD_TAG = attiny85at8

# Avrdude config path on the remote Raspberry Pi
AVRDUDE_CONF=/usr/local/etc/avrdude.conf

# Skip the monitor port existance check since it's not on our machine.
FORCE_MONITOR_PORT=true
MONITOR_PORT=/dev/spidev0.0

include ../../Arduino.mk


# Additional rules to use a remote Raspberry Pi programmer

# Note that it's recommended not to use root for this task,
# but to setup spidev access on a normal user instead.
HOST = root@alarmpi
SSH_AVRDUDE = ssh $(HOST) /usr/local/bin/avrdude

CAT_HEX = cat $(TARGET_HEX)
AVRDUDE_UPLOAD_PIPE = -U flash:w:-:i

.PHONY: net_upload net_set_fuses

net_upload: $(TARGET_HEX) verify_size
	$(CAT_HEX) | $(SSH_AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ARD_OPTS) \
		$(AVRDUDE_UPLOAD_PIPE)

net_set_fuses:
ifneq ($(strip $(AVRDUDE_ISP_FUSES_PRE)),)
		$(SSH_AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ARD_OPTS) -e \
		$(AVRDUDE_ISP_FUSES_PRE)
endif
ifneq ($(strip $(AVRDUDE_ISP_FUSES_POST)),)
		$(SSH_AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ARD_OPTS) \
		$(AVRDUDE_ISP_FUSES_POST)
endif
