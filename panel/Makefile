ifneq ($(theCmd),)
emmc := $(theCmd)
$(warning image link is $(emmc))
endif

.PHONY: all _down burn reboot
all: burn reboot

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

burn: _down _off _set_uboot _on _burn
	#vim -u NONE /tftp/emmc/emmc_image_list -c "%s/super.subimg,/super.subimg.gz,/g" -c ":wq"
	#-cd /tftp/emmc && gzip super.subimg
	@echo "Burn image"

_burn:
	@comBroker run   burn.json

_off: #clear modes
	@echo "Power OFF"
	@comBroker write off_1.json
	@comBroker write off_2.json
	sleep 3

_on:
	@echo "Power ON"
	@comBroker write on_2.json

_set_uboot:
	@echo "Set mode to UBOOT"
	@comBroker write on_1.json
	@sleep 2

_set_normal:
	@echo "Set mode to NORMAL"
	@comBroker write off_1.json
	@sleep 2

uboot: _off _set_uboot _on
	@echo "Power On to uboot"
boot: _off _on
	@echo "Power On to normal"
