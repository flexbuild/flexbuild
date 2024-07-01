# Copyright 2017-2023 NXP
#
# SPDX-License-Identifier: BSD-3-Clause
#
#
# SDK Networking Components


dce:
	@[ $(DESTARCH) != arm64 -o $(SOCFAMILY) != LS -o \
	   $(DISTROVARIANT) = tiny -o $(DISTROVARIANT) = base ] && exit || \
	 $(call fbprint_b,"dce") && \
	 $(call repo-mngr,fetch,dce,apps/networking) && \
	 cd $(NETDIR)/dce && \
	 sed -i 's/DESTDIR)\/sbin/DESTDIR)\/usr\/bin/' Makefile && \
	 sed -i 's/-Wwrite-strings -Wno-error/-Wwrite-strings -fcommon -Wno-error/' lib/qbman_userspace/Makefile && \
	 make clean  && \
	 $(MAKE) -j$(JOBS) ARCH=aarch64 && \
	 $(MAKE) -j$(JOBS) install && \
	 $(call fbprint_d,"dce")
