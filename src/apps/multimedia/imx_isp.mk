# Copyright 2021-2024 NXP
#
# SPDX-License-Identifier: BSD-3-Clause


# i.MX Verisilicon Software ISP on imx8mp

# DEPENDS: libtinyxml2 systemd libdrm libg2d



imx_isp:
	@[ $(DISTROVARIANT) != desktop -o $(DESTARCH) != arm64 ] && exit || \
	 $(call fbprint_b,"imx_isp") && \
	 cd $(MMDIR) && \
	 if [ ! -d $(MMDIR)/imx_isp ]; then \
	     wget -q $(repo_imx_isp_bin_url) -O imxisp.bin && \
	     chmod +x imxisp.bin && ./imxisp.bin --auto-accept && \
	     mv isp-imx-* imx_isp && rm -f imxisp.bin; \
	 fi && \
	 if [ ! -f $(DESTDIR)/usr/lib/libg2d.so ]; then \
	     bld imx_gpu_g2d -r $(DISTROTYPE):$(DISTROVARIANT) -f $(CFGLISTYML); \
	 fi && \
	 if [ ! -f $(DESTDIR)/usr/lib/libOpenCL.so ]; then \
	     bld gpu_viv -r $(DISTROTYPE):$(DISTROVARIANT) -f $(CFGLISTYML); \
	 fi && \
	 if [ ! -f $(DESTDIR)/usr/include/xf86drm.h ]; then \
	     bld libdrm -r $(DISTROTYPE):$(DISTROVARIANT) -f $(CFGLISTYML); \
	 fi && \
	 \
	 cd imx_isp/appshell && \
	 sed -i 's/imx\///' display/DrmDisplay.cpp display/WlDisplay.cpp v4l_drm_test/video_test.cpp && \
	 sudo cp -f ../mediacontrol/lib/arm-64/fpga/libtinyxml2.so $(RFSDIR)/usr/lib/libtinyxml2.so.9 && \
	 sudo ln -sf libtinyxml2.so.9 $(RFSDIR)/usr/lib/libtinyxml2.so && \
	 cp -Pf $(RFSDIR)/usr/lib/libtinyxml2.so* $(DESTDIR)/usr/lib && \
	 sudo cp -Pf $(DESTDIR)/usr/lib/libg2d*.so* $(RFSDIR)/usr/lib && \
	 mkdir -p build_$(DISTROTYPE)_$(ARCH) && cd build_$(DISTROTYPE)_$(ARCH) && \
	 export CC="$(CROSS_COMPILE)gcc --sysroot=$(RFSDIR)" && \
	 export CXX="$(CROSS_COMPILE)g++ --sysroot=$(RFSDIR)" && \
	 cmake .. -G "Unix Makefiles" \
		-DSDKTARGETSYSROOT=$(RFSDIR) \
		-DCMAKE_BUILD_TYPE=release \
		-DISP_VERSION=ISP8000NANO_V1802 \
		-DPLATFORM=ARM64 \
		-DAPPMODE=V4L2 \
		-DQTLESS=1 \
		-DFULL_SRC_COMPILE=1 \
		-DWITH_DRM=1 \
		-DWITH_DWE=1 \
		-DSERVER_LESS=1 \
		-DSUBDEV_V4L2=1 \
		-DENABLE_IRQ=1 \
		-DPARTITION_BUILD=0 \
		-D3A_SRC_BUILD=0 \
		-DIMX_G2D=ON \
		-Wno-dev \
		-DCMAKE_CXX_FLAGS="-I$(DESTDIR)/usr/include -I$(DESTDIR)/usr/include/libdrm \
			-Wno-error=variadic-macros -Wno-error=pedantic" && \
	 $(MAKE) -j$(JOBS) && \
	 install -d $(DESTDIR)/opt/imx8-isp/bin && \
	 install -d $(DESTDIR)/usr/lib/systemd/system && \
	 install -d $(DESTDIR)/etc/systemd/system/multi-user.target.wants && \
	 cp -rf generated/release/bin/*_test $(DESTDIR)/opt/imx8-isp/bin && \
	 cp -rf generated/release/bin/isp_media_server $(DESTDIR)/opt/imx8-isp/bin && \
	 cp -rf generated/release/bin/vvext $(DESTDIR)/opt/imx8-isp/bin && \
	 cp -Pf generated/release/lib/*.so* $(DESTDIR)/usr/lib && \
	 cp -rf generated/release/include/* $(DESTDIR)/usr/include && \
	 cp -rf generated/release/bin/*.xml $(DESTDIR)/opt/imx8-isp/bin && \
	 cp -rf generated/release/bin/*_test $(DESTDIR)/opt/imx8-isp/bin && \
	 cp -rf $(MMDIR)/imx_isp/dewarp/dewarp_config $(DESTDIR)/opt/imx8-isp/bin && \
	 cp $(MMDIR)/imx_isp/imx/run.sh $(DESTDIR)/opt/imx8-isp/bin && \
	 cp $(MMDIR)/imx_isp/imx/start_isp.sh $(DESTDIR)/opt/imx8-isp/bin && \
	 chmod +x $(DESTDIR)/opt/imx8-isp/bin/run.sh && \
	 chmod +x $(DESTDIR)/opt/imx8-isp/bin/start_isp.sh && \
	 sed -i 's/bin\/sh/bin\/bash/' $(DESTDIR)/opt/imx8-isp/bin/run.sh && \
	 find $(MMDIR)/imx_isp -name "*.drv" | xargs -I {} cp {} $(DESTDIR)/opt/imx8-isp/bin/ && \
	 install -m 0644 $(MMDIR)/imx_isp/imx/imx8-isp.service $(DESTDIR)/usr/lib/systemd/system/ && \
	 ln -sf /usr/lib/systemd/system/imx8-isp.service $(DESTDIR)/etc/systemd/system/multi-user.target.wants/imx8-isp.service && \
	 $(call fbprint_d,"imx_isp")
