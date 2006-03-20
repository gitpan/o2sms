use ExtUtils::MakeMaker;

WriteMakefile(
	NAME		=> 'o2sms',
	DISTNAME	=> 'o2sms',
	ABSTRACT	=> 'A module to send SMS messages using .ie websites',
	VERSION_FROM	=> 'bin/o2sms',
	EXE_FILES     => [ 'bin/o2sms', 'bin/vodasms', 'bin/meteorsms' ],
	PREREQ_PM	=> {
		Getopt::Long		=> 2.33,
		Term::ReadLine		=> 0,
		Storable		=> 0,
		TestGen4Web::Runner	=> 0.04,
		IO::Socket::SSL		=> 0,
		Net::SSLeay		=> 0,
		Crypt::SSLeay		=> 0,
		URI			=> 1.26,
	},
	dist		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);

sub MY::postamble {
	return <<'MAKE_FRAG';

publish-cpan: dist 
	echo "Going to upload " `ls -1t *.tar.gz | head -1`
	sleep 2
	/usr/bin/cpan-upload -user mackers -mailto me@mackers.com -verbose `ls -1t *.tar.gz | head -1`

debuild: META.yml dist
	mkdir /tmp/debuild-o2sms/
	cp `ls -1t *.tar.gz | head -1` /tmp/debuild-o2sms/
	cd /tmp/debuild-o2sms/ && tar -zxvf *.tar.gz
	rm /tmp/debuild-o2sms/*.tar.gz
	cp -R debian /tmp/debuild-o2sms/o2sms*
	cd /tmp/debuild-o2sms/o2sms* && debuild
	rm -rf /tmp/debuild-o2sms/o2sms-*
	mv /tmp/debuild-o2sms/* ./debuild/
	rmdir /tmp/debuild-o2sms/

publish-debian: dist debuild
	echo "Going to upload" `ls -1t debuild/*.changes | head -1`
	sleep 2
	/usr/bin/reprepro -Vb /var/www/hosts/apt.mackers.com/htdocs/ include unstable `ls -1t debuild/*.changes | head -1` 

publish-mackers.com: dist
	/usr/bin/pod2html -title o2sms -htmlroot . bin/o2sms  > /var/www/hosts/www.mackers.com/htdocs/projects/o2sms/docs/v3/usage.html
	/usr/bin/pod2html -title WWW::SMS::IE::iesms -htmlroot . lib/WWW/SMS/IE/iesms.pm > /var/www/hosts/www.mackers.com/htdocs/projects/o2sms/docs/v3/WWW/SMS/IE/iesms.html
	/usr/bin/pod2html -title WWW::SMS::IE::o2sms -htmlroot . lib/WWW/SMS/IE/o2sms.pm > /var/www/hosts/www.mackers.com/htdocs/projects/o2sms/docs/v3/WWW/SMS/IE/o2sms.html
	/usr/bin/pod2html -title WWW::SMS::IE::vodasms -htmlroot . lib/WWW/SMS/IE/vodasms.pm > /var/www/hosts/www.mackers.com/htdocs/projects/o2sms/docs/v3/WWW/SMS/IE/vodasms.html
	/usr/bin/pod2html -title WWW::SMS::IE::meteorsms -htmlroot . lib/WWW/SMS/IE/meteorsms.pm > /var/www/hosts/www.mackers.com/htdocs/projects/o2sms/docs/v3/WWW/SMS/IE/meteorsms.html
	find . -name '*.tmp' | xargs rm
	cp `ls -1t *.tar.gz | head -1` /var/www/hosts/www.mackers.com/htdocs/projects/o2sms/releases/

MAKE_FRAG
}

