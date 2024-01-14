ifneq ($(theCmd),)
emmc := $(theCmd)
$(warning image link is $(emmc))
endif

.PHONY: _down burn
.INTERMEDIATE: _down
_down:
ifeq ($(theCmd),)
	$(error image link is empty)
endif
	rm -fr eMMCimg emmc $@
	wget -q $(emmc) -O $@
	unzip $@
	mv eMMCimg emmc
	rm -fr /tftp/emmc
	mv emmc /tftp/

_off:
	@# power off
	@comBroker write cmdOff3.json
	@comBroker write cmdOff4.json
	@# clear uboot mode
	@comBroker write cmdOff2.json
	sleep 3

_on:
	@comBroker write cmdOn3.json
	@comBroker write cmdOn4.json

_set_uboot:
	@echo "Set mode to UBOOT"
	@comBroker write cmdOn2.json
	@sleep 2

_set_normal:
	@echo "Set mode to NORMAL"
	@comBroker write cmdOff2.json
	@sleep 2

_burn:
	@echo "Burning ..."
	@comBroker run   burn.json

uboot: _off _set_uboot _on
	@echo "Power On to uboot"
boot: _off _on
	@echo "Power On to normal"
burn: _down _off _set_uboot _on _burn
	@echo "Burn image"
