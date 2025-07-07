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

CITY := /codebase01/yyu
#CITY := $(HOME)/city

$(CITY)/$(theCmd)/android_r:
	mkdir -p $@
$(CITY)/$(theCmd)/android_s:
	mkdir -p $@
$(CITY)/$(theCmd)/android_t:
	mkdir -p $@
$(CITY)/$(theCmd)/android_u:
	mkdir -p $@
$(CITY)/$(theCmd)/s:
	mkdir -p $@

android_r_sync:
	cd $(CITY)/$(theCmd)/android_r && repo sync --force-sync
android_s_sync:
	cd $(CITY)/$(theCmd)/android_s && repo sync --force-sync
	# go build
android_t_sync:
	cd $(CITY)/$(theCmd)/android_t && repo sync --force-sync
android_u_sync:
	cd $(CITY)/$(theCmd)/android_u && repo sync --force-sync
android_b_sync:
	cd $(CITY)/$(theCmd)/android_b && repo sync --force-sync
android_sync_post:
	echo "android_sync_post()"

sdk_sync:
	cd $(CITY)/$(theCmd)/s && repo sync --force-sync
sdk_post_sync:
	git -C $(CITY)/$(theCmd)/s/drm/playready lfs pull
	test -d $(CITY)/$(theCmd)/s/synap/release          && git -C $(CITY)/$(theCmd)/s/synap/release lfs pull || exit 0
	test -d $(CITY)/$(theCmd)/s/synap/vsi_npu_sw_stack && git -C $(CITY)/$(theCmd)/s/synap/vsi_npu_sw_stack lfs pull || exit 0
	test -d $(CITY)/$(theCmd)/s/toolchain/oe/linux-x64/gcc-9.3.0-poky  && git -C $(CITY)/$(theCmd)/s/toolchain/oe/linux-x64/gcc-9.3.0-poky  lfs pull || exit 0
	test -d $(CITY)/$(theCmd)/s/toolchain/oe/linux-x64/gcc-11.3.0-poky && git -C $(CITY)/$(theCmd)/s/toolchain/oe/linux-x64/gcc-11.3.0-poky lfs pull || exit 0
	test -d $(CITY)/$(theCmd)/android_u/device/synaptics/common && git -C $(CITY)/$(theCmd)/android_u/device/synaptics/common lfs pull || exit 0
	# compiledb
	#cd $(CITY)/$(theCmd)/s/build && git fetch ssh://yyu@sc-debu-git.synaptics.com:29420/mms/vssdk/top refs/changes/94/180594/1 && git cherry-pick FETCH_HEAD
sdk_post_sync_U:
	test -d $(CITY)/$(theCmd)/s/linux_5_15 && git -C $(CITY)/$(theCmd)/s/linux_5_15 lfs pull || exit 0
sdk_post_sync_B:
	test -d $(CITY)/$(theCmd)/s/linux_5_15 && git -C $(CITY)/$(theCmd)/s/linux_5_15 lfs pull || exit 0

android_r_clean:
	cd $(CITY)/$(theCmd)/android_r && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(CITY)/$(theCmd)/android_r && repo forall -j1 -c "git clean -xdf"; exit 0
android_s_clean:
	cd $(CITY)/$(theCmd)/android_s && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(CITY)/$(theCmd)/android_s && repo forall -j1 -c "git clean -xdf"; exit 0
android_t_clean:
	cd $(CITY)/$(theCmd)/android_t && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(CITY)/$(theCmd)/android_t && repo forall -j1 -c "git clean -xdf"; exit 0
android_u_clean:
	cd $(CITY)/$(theCmd)/android_u && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(CITY)/$(theCmd)/android_u && repo forall -j1 -c "git clean -xdf"; exit 0
android_b_clean:
	cd $(CITY)/$(theCmd)/android_b && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(CITY)/$(theCmd)/android_b && repo forall -j1 -c "git clean -xdf"; exit 0
sdk_clean:
	cd $(CITY)/$(theCmd)/s && repo forall -j1 -c "git reset --hard"; exit 0
	cd $(CITY)/$(theCmd)/s && repo forall -j1 -c "git clean -xdf"; exit 0

android_r_aosp_init: | $(CITY)/$(theCmd)/android_r
	cd $(CITY)/$(theCmd)/android_r && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b rel_branch/vssdk/v1.7/202108201205 -m syna-r-aosp.xml
android_r_gms_init: | $(CITY)/$(theCmd)/android_r
	cd $(CITY)/$(theCmd)/android_r && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b rel_branch/vssdk/v1.7/202108201205 -m syna-r-tv-dev.xml
android_s_gms_init: | $(CITY)/$(theCmd)/android_s
	cd $(CITY)/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_s/master -m syna-s-tv-dev.xml
android_s_aosp_init: | $(CITY)/$(theCmd)/android_s
	cd $(CITY)/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_s/master -m syna-s-aosp.xml
musen_android_init: | $(CITY)/$(theCmd)/android_s
	cd $(CITY)/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs640/vssdk.ppd/202304131205 -m syna-s-aosp.xml
android_t_gms_init: | $(CITY)/$(theCmd)/android_t
	cd $(CITY)/$(theCmd)/android_t && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_t/master -m syna-tv-dev.xml
android_u_aosp_init: | $(CITY)/$(theCmd)/android_u
	cd $(CITY)/$(theCmd)/android_u  && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_u/master -m syna-aosp.xml
android_u_gms_init: | $(CITY)/$(theCmd)/android_u
	cd $(CITY)/$(theCmd)/android_u  && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_u/master -m syna-tv-dev.xml --depth=100
android_b_aosp_init: | $(CITY)/$(theCmd)/android_b
	cd $(CITY)/$(theCmd)/android_b  && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_b/master -m syna-aosp.xml --depth=100
android_b_gms_init: | $(CITY)/$(theCmd)/android_b
	cd $(CITY)/$(theCmd)/android_b  && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_b/master -m syna-aosp.xml --depth=1
android_t_aosp_init: | $(CITY)/$(theCmd)/android_t
	cd $(CITY)/$(theCmd)/android_t && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b dev_branch/android_t/master -m syna-aosp.xml
android_110_gms_init: | $(CITY)/$(theCmd)/android_s
	cd $(CITY)/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b rel_branch/vssdk/v1.10.1/202301101805 -m syna-s-tv-dev.xml
sdk_r_init: | $(CITY)/$(theCmd)/s
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b rel_branch/vssdk/v1.7/202108201205 -m vssdk.xml
sdk_110_init: | $(CITY)/$(theCmd)/s
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b rel_branch/vssdk/v1.10.1/202301101805 -m vssdk.xml
sdk_init: | $(CITY)/$(theCmd)/s
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b dev_branch/master -m vssdk.xml --depth=1
musen_sdk_init: | $(CITY)/$(theCmd)/s
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs640/vssdk.ppd/202304131205 -m vssdk.xml
pre_compile_r:
	cd $(CITY)/$(theCmd)/android_r && rm -fr out
	cd $(CITY)/$(theCmd)/s && rm -fr out
pre_compile_s:
	cd $(CITY)/$(theCmd)/android_s && rm -fr out
	cd $(CITY)/$(theCmd)/s && rm -fr out
pre_compile_t:
	cd $(CITY)/$(theCmd)/android_t && rm -fr out
	cd $(CITY)/$(theCmd)/s && rm -fr out
pre_compile_u:
	cd $(CITY)/$(theCmd)/android_u && rm -fr out
	cd $(CITY)/$(theCmd)/s && rm -fr out

#############################################################################
####                 			products                                 ####
#############################################################################

# musen
android_init_musen: musen_android_init
	echo DONE
sdk_init_musen: musen_sdk_init
	echo DONE
android_post_sync_musen:
	echo SKIP
pre_compile_musen: pre_compile_s
	echo $@ DONE
android_build_musen:
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_multi_lib_androidtv \
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
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
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
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
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
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
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
	cd $(CITY)/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
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
	cd $(CITY)/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_sl \
		-m ../s

# orca_S_GMS_31
android_init_orca_S_GMS_31: | $(CITY)/$(theCmd)/android_s
	cd $(CITY)/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs640/google_cert/202209221605 -m syna-s-tv-dev.xml
	echo DONE
sdk_init_orca_S_GMS_31: | $(CITY)/$(theCmd)/s
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs640/google_cert/202209221605 -m vssdk.xml
	echo DONE
android_post_sync_orca_S_GMS_31:
	echo SKIP
pre_compile_orca_S_GMS_31: pre_compile_s
	echo DONE
android_build_orca_S_GMS_31:
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/orca/configs/orca_sl -b userdebug_cl \
		-m ../s

# sequoia_S_GMS_29
android_init_sequoia_S_GMS_29: | $(CITY)/$(theCmd)/android_s
	cd $(CITY)/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m syna-s-tv-dev.xml
	echo DONE
sdk_init_sequoia_S_GMS_29: | $(CITY)/$(theCmd)/s
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m vssdk.xml
	echo DONE
android_post_sync_sequoia_S_GMS_29:
	echo SKIP
pre_compile_sequoia_S_GMS_29: pre_compile_s
	echo DONE
android_build_sequoia_S_GMS_29:
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
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
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
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
	cd $(CITY)/$(theCmd)/android_t && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/aosp_dolphin_tl \
		-m ../s

# dolphin_B_AOSP_36
android_init_dolphin_B_AOSP_36: android_b_aosp_init
	echo DONE
sdk_init_dolphin_B_AOSP_36: sdk_init
	echo DONE
android_post_sync_dolphin_B_AOSP_36:
	echo SKIP
sdk_post_sync_dolphin_B_AOSP_36: sdk_post_sync sdk_post_sync_B
	echo SKIP
android_build_dolphin_B_AOSP_36:
	cd $(CITY)/$(theCmd)/android_b && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/aosp_dolphin_bl \
		-m ../s

# dolphin_B_GMS_36
android_init_dolphin_B_GMS_36: android_b_gms_init
	echo DONE
sdk_init_dolphin_B_GMS_36: sdk_init
	echo DONE
android_post_sync_dolphin_B_GMS_36:
	echo SKIP
sdk_post_sync_dolphin_B_GMS_36: sdk_post_sync sdk_post_sync_B
	echo SKIP
android_build_dolphin_B_GMS_36:
	cd $(CITY)/$(theCmd)/android_b && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/aosp_dolphin_ul \
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
android_build_dolphin_U_AOSP_34:
#		-p vendor/synaptics/platypus/configs/aosp_platypus_ul
	cd $(CITY)/$(theCmd)/android_u && ./vendor/synaptics/build/build_androidtv \
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
	cd $(CITY)/$(theCmd)/android_u && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_ul_rdk \
		-m ../s

# dolphin_U_LTS_34
android_init_dolphin_U_LTS_34:
	cd $(CITY)/$(theCmd)/android_u && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b rel_branch/vssdk/v1.14/202412051605 -m syna-tv-dev.xml --depth=100
	echo DONE
sdk_init_dolphin_U_LTS_34: sdk_init
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b rel_branch/vssdk/v1.14/202412051605 -m vssdk.xml
	echo DONE
android_post_sync_dolphin_U_LTS_34:
	echo SKIP
sdk_post_sync_dolphin_U_LTS_34: sdk_post_sync sdk_post_sync_U
	echo $@ DONE
android_build_dolphin_U_LTS_34:
	# done
	cd $(CITY)/$(theCmd)/android_u && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_ul \
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
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_multi_lib_androidtv \
		-p vendor/synaptics/dolphin/configs/aosp_dolphin_sl_noip \
		-m ../s

# cf_master_aosp
android_init_cf_master_aosp:
	cd $(CITY)/$(theCmd) && repo init -u git://mirrors.ustc.edu.cn/aosp/platform/manifest -b master
	echo DONE
sdk_init_cf_master_aosp:
	echo DO NOTHING
android_post_sync_cf_master_aosp:
	echo SKIP
pre_compile_cf_master_aosp:
	echo $@ DONE
android_build_cf_master_aosp:
	cd $(CITY)/$(theCmd) && ./run.sh
#special targets
aosp_clean:
	cd $(CITY)/$(theCmd) && rm -fr out
	cd $(CITY)/$(theCmd) && repo forall -c "git reset --hard"; exit 0
	cd $(CITY)/$(theCmd) && repo forall -c "git clean -xdf"; exit 0
aosp_sync:
	cd $(CITY)/$(theCmd) && repo sync --force-sync

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
	echo SKIP
sdk_post_sync_dolphin_110_GMS: sdk_post_sync
	echo SKIP
pre_compile_dolphin_110_GMS: pre_compile_s
	echo $@ DONE
android_build_dolphin_110_GMS:
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/platypus/configs/platypus_sl \
		-m ../s

# bg5ct_s
android_init_bg5ct_s:
	cd $(CITY)/$(theCmd)/android_s && repo init -u ssh://sc-debu-git.synaptics.com:29420/by-projects/android/manifests -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m syna-s-tv-dev.xml
	echo DONE
sdk_init_bg5ct_s:
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://sc-debu-git.synaptics.com:29420/debu/manifest -b wip_branch/vssdk/android_s/vs550/google_cert/202204291605 -m vssdk.xml
	echo DONE
android_post_sync_bg5ct_s:
	echo SKIP
pre_compile_bg5ct_s: pre_compile_s
	echo $@ DONE
android_build_bg5ct_s:
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/sequoia/configs/sequoia_ql_ab_v4 \
		-m ../s

# SKB-AI2: q_sequoia_ql_v4
# bg5ct_q (1.4)
android_init_bg5ct_q:
	cd $(CITY)/$(theCmd)/android_q && repo init -u ssh://debugithub.synaptics.com:29418/manifest -b m/cd/cust/mdk/rel_branch/vssdk/v1.4/201912041805/q_sequoia_ql_v4/202010210832
	echo DONE
sdk_init_bg5ct_q:
	cd $(CITY)/$(theCmd)/s && repo init -u ssh://debugithub.synaptics.com:29418/manifest -b VSSDK_Doc
	echo DONE
android_post_sync_bg5ct_q:
	echo SKIP
pre_compile_bg5ct_q: pre_compile_s
	echo $@ DONE
android_build_bg5ct_q:
	cd $(CITY)/$(theCmd)/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/sequoia/configs/sequoia_ol_v4 \
		-m ../s

sdk_defconfig:
	echo profile=$(profile)
	cd $(CITY)/dolphin_S_GMS/android_s && ./vendor/synaptics/build/build_androidtv \
		-p vendor/synaptics/dolphin/configs/dolphin_sl \
		-m ../s \
		-sprepare

# soong: add patch to fix build error
# sdk/build: generate json for bl
