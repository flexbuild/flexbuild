#
# Copyright 2017-2023 NXP
#
# SPDX-License-Identifier: BSD-3-Clause
#
#
# SDK Application Components
#

SHELL=/bin/bash
include $(FBDIR)/configs/$(CONFIGLIST)
include $(FBDIR)/include/repo.mk


GRAPHICSDIR = $(PKGDIR)/apps/graphics
CONNDIR = $(PKGDIR)/apps/connectivity
MMDIR = $(PKGDIR)/apps/multimedia
NETDIR = $(PKGDIR)/apps/networking
SECDIR = $(PKGDIR)/apps/security
UTILSDIR = $(PKGDIR)/apps/utils
MLDIR = $(PKGDIR)/apps/ml


all: $(APPS_REPO_LIST)
	@$(call fbprint_d,"apps components")


connectivity: $(CONNECTIVITY_REPO_LIST)
networking:   $(NETWORKING_REPO_LIST)
multimedia:   $(MULTIMEDIA_REPO_LIST)
graphics:     $(GRAPHICS_REPO_LIST)
security:     $(SECURITY_REPO_LIST)
utils:        $(UTILS_REPO_LIST)
ml:	      $(ML_REPO_LIST)


include $(sort $(wildcard $(FBDIR)/src/apps/*/*.mk))
include $(FBDIR)/include/repo_update.inc
