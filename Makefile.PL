use ExtUtils::MakeMaker;

WriteMakefile(
	NAME		=> 'o2sms',
	DISTNAME	=> 'o2sms',
	ABSTRACT	=> 'A module to send SMS messages using .ie websites',
	VERSION_FROM	=> 'bin/o2sms',
	EXE_FILES     => [ 'bin/o2sms', 'bin/vodasms', 'bin/meteorsms' ],
	PREREQ_PM	=> {
		Getopt::Long		=> 0,
		Term::ReadLine		=> 0,
		Storable		=> 0,
		TestGen4Web::Runner	=> 0,
		IO::Socket::SSL		=> 0,
		Net::SSLeay		=> 0,
		Crypt::SSLeay		=> 0,
	},
	dist		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);

sub MY::postamble {
	return <<'MAKE_FRAG';

cpanupload: 
	echo "Going to upload " `ls -1t *.tar.gz | head -1`
	/usr/bin/cpan-upload -user mackers -mailto me@mackers.com -verbose `ls -1t *.tar.gz | head -1`

debuild: META.yml
	mkdir /tmp/debuild-o2sms/
	cp `ls -1t *.tar.gz | head -1` /tmp/debuild-o2sms/
	cd /tmp/debuild-o2sms/ && tar -zxvf *.tar.gz
	rm /tmp/debuild-o2sms/*.tar.gz
	cp -R debian /tmp/debuild-o2sms/o2sms*
	cd /tmp/debuild-o2sms/o2sms* && debuild
	rm -rf /tmp/debuild-o2sms/o2sms-*
	mv /tmp/debuild-o2sms/* ./debuild/
	rmdir /tmp/debuild-o2sms/

debupload:
	echo "Going to upload" `ls -1t debuild/*.changes | head -1`
	/usr/bin/reprepro -Vb /var/www/hosts/apt.mackers.com/htdocs/ include unstable `ls -1t debuild/*.changes | head -1` 

MAKE_FRAG
}

