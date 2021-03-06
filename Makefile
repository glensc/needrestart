all:
	cd perl && perl Makefile.PL PREFIX=$(PREFIX) INSTALLDIRS=vendor 
	cd perl && $(MAKE)

install: all
	cd perl && $(MAKE) install
	
	mkdir -p "$(DESTDIR)/etc/needrestart/hook.d"
	cp hooks/* "$(DESTDIR)/etc/needrestart/hook.d/"
	cp ex/needrestart.conf "$(DESTDIR)/etc/needrestart/"
	mkdir -p "$(DESTDIR)/etc/needrestart/conf.d"
	cp ex/conf.d/* "$(DESTDIR)/etc/needrestart/conf.d/"
	mkdir -p "$(DESTDIR)/etc/needrestart/notify.d"
	cp ex/notify.d/* "$(DESTDIR)/etc/needrestart/notify.d/"
	
	which apt-get > /dev/null && \
	    mkdir -p "$(DESTDIR)/etc/apt/apt.conf.d" && cp ex/apt/needrestart-apt_d "$(DESTDIR)/etc/apt/apt.conf.d/99needrestart" && \
	    mkdir -p "$(DESTDIR)/etc/dpkg/dpkg.cfg.d" && cp ex/apt/needrestart-dpkg_d "$(DESTDIR)/etc/dpkg/dpkg.cfg.d/needrestart" && \
	    mkdir -p "$(DESTDIR)/usr/lib/needrestart" && cp ex/apt/dpkg-status ex/apt/apt-pinvoke "$(DESTDIR)/usr/lib/needrestart" || true
	
	which debconf > /dev/null && \
	    mkdir -p "$(DESTDIR)/usr/share/needrestart" && \
	    po2debconf ex/debconf/needrestart.templates > "$(DESTDIR)/usr/share/needrestart/needrestart.templates" || true
	
	mkdir -p "$(DESTDIR)/usr/sbin"
	cp needrestart "$(DESTDIR)/usr/sbin/"

clean:
	[ ! -f perl/Makefile ] || ( cd perl && $(MAKE) realclean ) 
