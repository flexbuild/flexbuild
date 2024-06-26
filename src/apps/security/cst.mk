# Copyright 2017-2023 NXP
#
# SPDX-License-Identifier: BSD-3-Clause



cst:
	@[ $(DISTROVARIANT) = tiny -o $(DISTROVARIANT) = base -o $(SOCFAMILY) != LS ] && exit || \
	 $(call fbprint_b,"CST") && \
	 $(call repo-mngr,fetch,cst,apps/security) && \
	 cd $(SECDIR)/cst && \
	 sed -i 's/^struct input_field/extern struct input_field/g' tools/*/*.c && \
	 sed -i 's/-g -Wall/-g -Wno-deprecated-declarations -Wall/' Makefile && \
	 $(MAKE) -j$(JOBS) && \
	 if [ -n "$(SECURE_PRI_KEY)" ]; then \
	     echo Using specified $(SECURE_PRI_KEY) and $(SECURE_PUB_KEY) ... ; \
	     cp -f $(SECURE_PRI_KEY) $(SECDIR)/cst/srk.pri; \
	     cp -f $(SECURE_PUB_KEY) $(SECDIR)/cst/srk.pub; \
	 elif [ ! -f srk.pri -o ! -f srk.pub ]; then \
	     ./gen_keys 1024 && echo "Generated new keys!"; \
	 else \
	     echo "Using default keys srk.pri and srk.pub"; \
	 fi && \
	 $(call fbprint_d,"CST")
