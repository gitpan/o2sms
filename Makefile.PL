use ExtUtils::MakeMaker;

WriteMakefile(
	NAME		=> 'o2sms',
	DISTNAME	=> 'o2sms',
	VERSION_FROM	=> 'bin/o2sms',
	EXE_FILES     => [ 'bin/o2sms', 'bin/vodasms', 'bin/meteorsms' ],
	PREREQ_PM	=> {
		Getopt::Long		=> 0,
		Term::ReadLine		=> 0,
		Storable		=> 0,
		TestGen4Web::Runner	=> 0,
	},
	dist		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
