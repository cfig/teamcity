colon:= :
empty:=
space:= $(empty) $(empty)
_libs := $(wildcard lib/*.jar)
libs := $(subst $(space),$(colon),$(_libs))

hn := $(shell uname -n)
KT := kotlinc
ifeq 'sha2upp-eng06' '$(hn)'
KT := $(HOME)/.sdkman/candidates/kotlin/current/bin/kotlinc
endif
ifeq 'sha2upp-eng05' '$(hn)'
KT := $(HOME)/.sdkman/candidates/kotlin/current/bin/kotlinc
endif
ifeq 'android100' '$(hn)'
KT := $(HOME)/.programs/plugged/kotlinc/bin/kotlinc
endif

all: export PATH := $(HOME)/.programs/11.0.2-open/bin:$(PATH)
all:
	java -version
	$(KT) -script tc.kts $(theCmd) -cp $(libs)

buildAll: export PATH := $(HOME)/.programs/11.0.2-open/bin:$(PATH)
buildAll:
	java -version
	$(KT) -script ba.kts $(theCmd) -cp $(libs)

$(HOME)/city/$(theCmd)/android_r:
	mkdir -p $@
$(HOME)/city/$(theCmd)/android_s:
	mkdir -p $@
$(HOME)/city/$(theCmd)/android_t:
	mkdir -p $@
$(HOME)/city/$(theCmd)/android_u:
	mkdir -p $@
$(HOME)/city/$(theCmd)/s:
	mkdir -p $@

android_r_sync:
	cd $(HOME)/city/$(theCmd)/android_r && repo sync --force-sync
android_s_sync:
	cd $(HOME)/city/$(theCmd)/android_s && repo sync --force-sync
	# go build
android_t_sync:
	cd $(HOME)/city/$(theCmd)/android_t && repo sync --force-sync
android_u_sync:
	cd $(HOME)/city/$(theCmd)/android_u && repo sync --force-sync
android_sync_post:
	echo "android_sync_post()"

sdk_sync:
	cd $(HOME)/city/$(theCmd)/s && repo sync --force-sync
sdk_post_sync:
	git -C $(HOME)/city/$(theCmd)/s/drm/playready lfs pull
	test -d $(HOME)/city/$(theCmd)/s/synap/release          && git -C $(HOME)/city/$(theCmd)/s/synap/release lfs pull || exit 0
	test -d $(HOME)/city/$(theCmd)/s/synap/vsi_npu_sw_stack && git -C $(HOME)/city/$(theCmd)/s/synap/vsi_npu_sw_stack lfs pull || exit 0
	test -d $(HOME)/city/$(theCmd)/s/toolchain/oe/linux-x64/gcc-9.3.0-poky  && git -C $(HOME)/city/$(theCmd)/s/toolchain/oe/linux-x64/gcc-9.3.0-poky  lfs pull || exit 0
	test -d $(HOME)/city/$(theCmd)/s/toolchain/oe/linux-x64/gcc-11.3.0-poky && git -C $(HOME)/city/$(theCmd)/s/toolchain/oe/linux-x64/gcc-11.3.0-poky lfs pull || exit 0
	test -d $(HOME)/city/$(theCmd)/android_u/device/synaptics/common && git -C $(HOME)/city/$(theCmd)/android_u/device/synaptics/common lfs pull || exit 0
	# compiledb
	#cd $(HOME)/city/$(theCmd)/s/build && git fetch ssh://yyu@sc-debu-git.synaptics.com:29420/mms/vssdk/top refs/changes/94/180594/1 && git cherry-pick FETCH_HEAD
sdk_post_sync_U:
	test -d $(HOME)/city/$(theCmd)/s/linux_5_15 && git -C $(HOME)/city/$(theCmd)/s/linux_5_15 lfs pull || exit 0

android_r_clean:
	cd $(HOME)/city/$(theCmd)/android_r && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(HOME)/city/$(theCmd)/android_r && repo forall -j1 -c "git clean -xdf"; exit 0
android_s_clean:
	cd $(HOME)/city/$(theCmd)/android_s && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(HOME)/city/$(theCmd)/android_s && repo forall -j1 -c "git clean -xdf"; exit 0
android_t_clean:
	cd $(HOME)/city/$(theCmd)/android_t && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(HOME)/city/$(theCmd)/android_t && repo forall -j1 -c "git clean -xdf"; exit 0
android_u_clean:
	cd $(HOME)/city/$(theCmd)/android_u && repo forall -j1 -c "git reset --hard"
	cd $(HOME)/city/$(theCmd)/android_u && repo forall -j1 -c "git clean -xdf"
sdk_clean:
	cd $(HOME)/city/$(theCmd)/s && repo forall -j1 -c "git reset --hard"
	cd $(HOME)/city/$(theCmd)/s && repo forall -j1 -c "git clean -xdf"

android_r_aosp_init: | $(HOME)/city/$(theCmd)/android_r
	cd $(HOME)/city/$(theCmd)/android_r && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b rel_branch/vssdk/v1.7/202108201205 -m syna-r-aosp.xml
android_r_gms_init: | $(HOME)/city/$(theCmd)/android_r
	cd $(HOME)/city/$(theCmd)/android_r && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b rel_branch/vssdk/v1.7/202108201205 -m syna-r-tv-dev.xml
android_s_gms_init: | $(HOME)/city/$(theCmd)/android_s
	cd $(HOME)/city/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_s/master -m syna-s-tv-dev.xml
android_s_aosp_init: | $(HOME)/city/$(theCmd)/android_s
	cd $(HOME)/city/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_s/master -m syna-s-aosp.xml
musen_android_init: | $(HOME)/city/$(theCmd)/android_s
	cd $(HOME)/city/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs640/vssdk.ppd/202304131205 -m syna-s-aosp.xml
android_t_gms_init: | $(HOME)/city/$(theCmd)/android_t
	cd $(HOME)/city/$(theCmd)/android_t && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_t/master -m syna-tv-dev.xml
android_u_aosp_init: | $(HOME)/city/$(theCmd)/android_u
	cd $(HOME)/city/$(theCmd)/android_u  && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_u/master -m syna-aosp.xml
android_u_gms_init: | $(HOME)/city/$(theCmd)/android_u
	cd $(HOME)/city/$(theCmd)/android_u  && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_u/master -m syna-tv-dev.xml --depth=100
android_t_aosp_init: | $(HOME)/city/$(theCmd)/android_t
	cd $(HOME)/city/$(theCmd)/android_t && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_t/master -m syna-aosp.xml
android_110_gms_init: | $(HOME)/city/$(theCmd)/android_s
	cd $(HOME)/city/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b rel_branch/vssdk/v1.10.1/202301101805 -m syna-s-tv-dev.xml
sdk_r_init: | $(HOME)/city/$(theCmd)/s
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b rel_branch/vssdk/v1.7/202108201205 -m vssdk.xml
sdk_110_init: | $(HOME)/city/$(theCmd)/s
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b rel_branch/vssdk/v1.10.1/202301101805 -m vssdk.xml
sdk_init: | $(HOME)/city/$(theCmd)/s
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b dev_branch/master -m vssdk.xml
musen_sdk_init: | $(HOME)/city/$(theCmd)/s
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs640/vssdk.ppd/202304131205 -m vssdk.xml
pre_compile_r:
	cd $(HOME)/city/$(theCmd)/android_r && rm -fr out
	cd $(HOME)/city/$(theCmd)/s && rm -fr out
pre_compile_s:
	cd $(HOME)/city/$(theCmd)/android_s && rm -fr out
	cd $(HOME)/city/$(theCmd)/s && rm -fr out
pre_compile_t:
	cd $(HOME)/city/$(theCmd)/android_t && rm -fr out
	cd $(HOME)/city/$(theCmd)/s && rm -fr out
pre_compile_u:
	cd $(HOME)/city/$(theCmd)/android_u && rm -fr out
	cd $(HOME)/city/$(theCmd)/s && rm -fr out

#############################################################################
####                 			products                                 ####
#############################################################################

# musen
android_init_musen: musen_android_init
	echo DONE
sdk_init_musen: musen_sdk_init
	echo DONE
android_post_sync_musen:
	cd $(HOME)/city/$(theCmd)/android_s/vendor/synaptics/platypus && git fetch ssh://yyu@sc-debu-git.synaptics.com:29420/by-projects/android/platform/vendor/synaptics/platypus refs/changes/04/185404/1 && git cherry-pick FETCH_HEAD
	cd $(HOME)/city/$(theCmd)/android_s/device/synaptics/platypus && git fetch ssh://yyu@sc-debu-git.synaptics.com:29420/by-projects/android/device/synaptics/platypus refs/changes/33/185533/2 && git cherry-pick FETCH_HEAD
	cd $(HOME)/city/$(theCmd)/android_s/vendor/synaptics/common && git fetch ssh://yyu@sc-debu-git.synaptics.com:29420/by-projects/android/platform/vendor/synaptics/common refs/changes/27/185527/2 && git cherry-pick FETCH_HEAD
	echo SKIP
pre_compile_musen: pre_compile_s
	echo $@ DONE
android_build_musen:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_multi_lib_androidtv \
		-p vendor/synaptics/platypus/configs/aosp_musen_sl_64b \
		-m ../s

# platypus_S_AOSP_31
android_init_platypus_S_AOSP_31: android_s_aosp_init
	echo DONE
sdk_init_platypus_S_AOSP_31: sdk_init
	echo DONE
android_post_sync_platypus_S_AOSP_31:
	echo SKIP
pre_compile_platypus_S_AOSP_31: pre_compile_s
	echo $@ DONE
android_build_platypus_S_AOSP_31:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/aosp_platypus_sl_rdk \
		-m ../s

# platypus_S_GMS_31
android_init_platypus_S_GMS_31: android_s_gms_init
	echo DONE
sdk_init_platypus_S_GMS_31: sdk_init
	echo DONE
android_post_sync_platypus_S_GMS_31:
	echo SKIP
pre_compile_platypus_S_GMS_31: pre_compile_s
	echo $@ DONE
android_build_platypus_S_GMS_31:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_sl \
		-m ../s

# platypus_S_GMS_30
android_init_platypus_S_GMS_30: android_s_gms_init
	echo DONE
sdk_init_platypus_S_GMS_30: sdk_init
	echo DONE
android_post_sync_platypus_S_GMS_30:
	echo SKIP
pre_compile_platypus_S_GMS_30: pre_compile_s
	echo $@ DONE
android_build_platypus_S_GMS_30:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_rl \
		-m ../s

# platypus_T_GMS_33
android_init_platypus_T_GMS_33: android_t_gms_init
	echo DONE
sdk_init_platypus_T_GMS_33: sdk_init
	echo DONE
android_post_sync_platypus_T_GMS_33:
	echo SKIP
pre_compile_platypus_T_GMS_33: pre_compile_t t_common
	echo $@ DONE
android_build_platypus_T_GMS_33:
	cd $(HOME)/city/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_tl \
		-m ../s

# platypus_T_GMS_31
android_init_platypus_T_GMS_31: android_t_gms_init
	echo DONE
sdk_init_platypus_T_GMS_31: sdk_init
	echo DONE
android_post_sync_platypus_T_GMS_31:
	echo SKIP
pre_compile_platypus_T_GMS_31: pre_compile_t t_common
	echo $@ DONE
android_build_platypus_T_GMS_31:
	cd $(HOME)/city/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_sl \
		-m ../s

# orca_S_GMS_31
android_init_orca_S_GMS_31: | $(HOME)/city/$(theCmd)/android_s
	cd $(HOME)/city/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs640/google_cert/202209221605 -m syna-s-tv-dev.xml
	echo DONE
sdk_init_orca_S_GMS_31: | $(HOME)/city/$(theCmd)/s
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs640/google_cert/202209221605 -m vssdk.xml
	echo DONE
android_post_sync_orca_S_GMS_31:
	echo SKIP
pre_compile_orca_S_GMS_31: pre_compile_s
	echo DONE
android_build_orca_S_GMS_31:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/orca/configs/orca_sl -b userdebug_cl \
		-m ../s

# sequoia_S_GMS_29
android_init_sequoia_S_GMS_29: | $(HOME)/city/$(theCmd)/android_s
	cd $(HOME)/city/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m syna-s-tv-dev.xml
	echo DONE
sdk_init_sequoia_S_GMS_29: | $(HOME)/city/$(theCmd)/s
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m vssdk.xml
	echo DONE
android_post_sync_sequoia_S_GMS_29:
	echo SKIP
pre_compile_sequoia_S_GMS_29: pre_compile_s
	echo DONE
android_build_sequoia_S_GMS_29:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/sequoia/configs/sequoia_ql_ab_v4 \
		-m ../s

# dolphin_S_GMS
android_init_dolphin_S_GMS: android_s_gms_init
	echo DONE
sdk_init_dolphin_S_GMS: sdk_init
	echo DONE
android_post_sync_dolphin_S_GMS:
	echo DONE
sdk_post_sync_dolphin_S_GMS: sdk_post_sync
	echo DONE
pre_compile_dolphin_S_GMS: pre_compile_s
	echo $@ DONE
android_build_dolphin_S_GMS:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_sl \
		-m ../s

# dolphin_T_AOSP_33
android_init_dolphin_T_AOSP_33: android_t_aosp_init
	echo DONE
sdk_init_dolphin_T_AOSP_33: sdk_init
	echo DONE
android_post_sync_dolphin_T_AOSP_33:
	echo SKIP
pre_compile_dolphin_T_AOSP_33: pre_compile_t t_common
	echo $@ DONE
android_build_dolphin_T_AOSP_33:
	cd $(HOME)/city/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/aosp_dolphin_tl \
		-m ../s

# dolphin_U_AOSP_34
android_init_dolphin_U_AOSP_34: android_u_aosp_init
	echo DONE
sdk_init_dolphin_U_AOSP_34: sdk_init
	echo DONE
android_post_sync_dolphin_U_AOSP_34:
	echo SKIP
sdk_post_sync_dolphin_U_AOSP_34: sdk_post_sync sdk_post_sync_U
	echo SKIP
pre_compile_dolphin_U_AOSP_34: pre_compile_u u_common
	echo $@ DONE
android_build_dolphin_U_AOSP_34:
	cd $(HOME)/city/$(theCmd)/android_u && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/aosp_dolphin_ul \
		-m ../s

# dolphin_U_GMS_34
android_init_dolphin_U_GMS_34: android_u_gms_init
	echo DONE
sdk_init_dolphin_U_GMS_34: sdk_init
	echo DONE
android_post_sync_dolphin_U_GMS_34:
	echo SKIP
sdk_post_sync_dolphin_U_GMS_34: sdk_post_sync sdk_post_sync_U
	echo $@ DONE
android_build_dolphin_U_GMS_34:
	cd $(HOME)/city/$(theCmd)/android_u && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_ul \
		-m ../s

# dolphin_U_CERT
android_init_dolphin_U_cert:
	cd $(HOME)/city/$(theCmd)/android_u && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_u/vs6x0/google_cert/202408311605 -m syna-tv-dev.xml --depth=100
	echo DONE
sdk_init_dolphin_U_cert: sdk_init
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_u/vs6x0/google_cert/202408311605 -m vssdk.xml
	echo DONE
android_post_sync_dolphin_U_cert:
	echo SKIP
sdk_post_sync_dolphin_U_cert: sdk_post_sync sdk_post_sync_U
	echo $@ DONE
android_build_dolphin_U_cert:
	cd $(HOME)/city/$(theCmd)/android_u && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_ul \
		-m ../s

# platypus_T_GMS
android_init_platypus_T_GMS: android_t_gms_init
	echo DONE
sdk_init_platypus_T_GMS: sdk_init
	echo DONE
android_post_sync_platypus_T_GMS:
	echo SKIP
pre_compile_platypus_T_GMS: pre_compile_t t_common
	cd $(HOME)/city/$(theCmd)/s/boot/bootloader && repo download 180582
	echo $@ DONE
android_build_platypus_T_GMS:
	cd $(HOME)/city/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_tl \
		-m ../s

# dolphin_T_GMS_33
android_init_dolphin_T_GMS_33: android_t_gms_init
	echo DONE
sdk_init_dolphin_T_GMS_33: sdk_init
	echo DONE
android_post_sync_dolphin_T_GMS_33:
	echo SKIP
pre_compile_dolphin_T_GMS_33: pre_compile_t t_common
	echo $@ DONE
android_build_dolphin_T_GMS_33:
	cd $(HOME)/city/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_tl \
		-m ../s

# dolphin_T_GMS_31
android_init_dolphin_T_GMS_31: android_t_gms_init
	echo DONE
sdk_init_dolphin_T_GMS_31: sdk_init
	echo DONE
android_post_sync_dolphin_T_GMS_31:
	echo SKIP
pre_compile_dolphin_T_GMS_31: pre_compile_t t_common
	echo $@ DONE
android_build_dolphin_T_GMS_31:
	cd $(HOME)/city/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_sl -b userdebug_cl \
		-m ../s

# dolphin_R_GMS_30
android_init_dolphin_R_GMS_30: android_r_gms_init
	echo DONE
sdk_init_dolphin_R_GMS_30: sdk_r_init
	echo DONE
android_post_sync_dolphin_R_GMS_30:
	echo SKIP
pre_compile_dolphin_R_GMS_30: pre_compile_r
	echo $@ DONE
android_build_dolphin_R_GMS_30:
	cd $(HOME)/city/$(theCmd)/android_r && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_rl_a0  \
		-m ../s

# dolphin_S_AOSP_31
android_init_dolphin_S_AOSP_31: android_s_aosp_init
	echo DONE
sdk_init_dolphin_S_AOSP_31: sdk_init
	echo DONE
android_post_sync_dolphin_S_AOSP_31:
	echo SKIP
pre_compile_dolphin_S_AOSP_31: pre_compile_s
	echo $@ DONE
android_build_dolphin_S_AOSP_31:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_multi_lib_androidtv \
		-p vendor/synaptics/dolphin/configs/aosp_dolphin_sl_noip \
		-m ../s

# cf_master_aosp
android_init_cf_master_aosp:
	cd $(HOME)/city/$(theCmd) && repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest -b master
	echo DONE
sdk_init_cf_master_aosp:
	echo DO NOTHING
android_post_sync_cf_master_aosp:
	echo SKIP
pre_compile_cf_master_aosp:
	echo $@ DONE
android_build_cf_master_aosp:
	cd $(HOME)/city/$(theCmd) && ./run.sh
#special targets
aosp_clean:
	cd $(HOME)/city/$(theCmd) && rm -fr out
	cd $(HOME)/city/$(theCmd) && repo forall -c "git reset --hard"; exit 0
	cd $(HOME)/city/$(theCmd) && repo forall -c "git clean -xdf"; exit 0
aosp_sync:
	cd $(HOME)/city/$(theCmd) && repo sync --force-sync

t_common:
	echo DONE

u_common:
	echo (u_common)DONE

# dolphin_110_GMS
android_init_dolphin_110_GMS: android_110_gms_init
	echo DONE
sdk_init_dolphin_110_GMS: sdk_110_init
	echo DONE
android_post_sync_dolphin_110_GMS:
	# boot
	cd $(HOME)/city/$(theCmd)/s/boot/common && git fetch ssh://yyu@gerrit-sha.synaptics.com:29420/debu/mboot/common refs/changes/09/246909/11 && git cherry-pick FETCH_HEAD
	cd $(HOME)/city/$(theCmd)/s/boot/common && git fetch ssh://yyu@gerrit-sha.synaptics.com:29420/debu/mboot/common refs/changes/21/246921/3 && git cherry-pick FETCH_HEAD
	cd $(HOME)/city/$(theCmd)/s/boot/common && git fetch ssh://yyu@gerrit-sha.synaptics.com:29420/debu/mboot/common refs/changes/27/246927/1 && git cherry-pick FETCH_HEAD
	#uboot
	cd $(HOME)/city/$(theCmd)/s/boot/u-boot_2019_10 && git fetch ssh://yyu@gerrit-sha.synaptics.com:29420/debu/mboot/external/u-boot refs/changes/30/246930/1 && git cherry-pick FETCH_HEAD
	# android
	cd $(HOME)/city/$(theCmd)/android_s/vendor/synaptics/common && git fetch ssh://yyu@gerrit-sha.synaptics.com:29420/by-projects/android/platform/vendor/synaptics/common refs/changes/24/246924/1 && git cherry-pick FETCH_HEAD
	echo SKIP
sdk_post_sync_dolphin_110_GMS: sdk_post_sync
	echo SKIP
pre_compile_dolphin_110_GMS: pre_compile_s
	echo $@ DONE
android_build_dolphin_110_GMS:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_sl \
		-m ../s

# bg5ct_s
android_init_bg5ct_s:
	cd $(HOME)/city/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m syna-s-tv-dev.xml
	echo DONE
sdk_init_bg5ct_s:
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m vssdk.xml
	echo DONE
android_post_sync_bg5ct_s:
	echo SKIP
pre_compile_bg5ct_s: pre_compile_s
	echo $@ DONE
android_build_bg5ct_s:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/sequoia/configs/sequoia_ql_ab_v4 \
		-m ../s

# SKB-AI2: q_sequoia_ql_v4
# bg5ct_q (1.4)
android_init_bg5ct_q:
	cd $(HOME)/city/$(theCmd)/android_q && repo init -u ssh://debugithub.synaptics.com:29418/manifest -b m/cd/cust/mdk/rel_branch/vssdk/v1.4/201912041805/q_sequoia_ql_v4/202010210832
	echo DONE
sdk_init_bg5ct_q:
	cd $(HOME)/city/$(theCmd)/s && repo init -u ssh://debugithub.synaptics.com:29418/manifest -b VSSDK_Doc
	echo DONE
android_post_sync_bg5ct_q:
	echo SKIP
pre_compile_bg5ct_q: pre_compile_s
	echo $@ DONE
android_build_bg5ct_q:
	cd $(HOME)/city/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/sequoia/configs/sequoia_ol_v4 \
		-m ../s

sdk_defconfig:
	echo profile=$(profile)
	cd $(HOME)/city/dolphin_S_GMS/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_sl \
		-m ../s \
		-sprepare

# soong: add patch to fix build error
# sdk/build: generate json for bl
