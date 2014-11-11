use 5.010001;

use strict;
use warnings;

use ExtUtils::MakeMaker;

# Pod::Simple 3.09 first shipped with Perl 5.11.2
# Time::Local 1.2 first shipped with Perl 5.13.9
# IO::Socket::IP 0.26 first shipped with Perl 5.19.8
WriteMakefile(
  NAME         => 'Shariff',
  VERSION_FROM => 'lib/Heise/Shariff.pm',
  ABSTRACT     => '',
  AUTHOR       => 'Philipp Busse <pmb@heise.de>',
  META_MERGE   => {
    requires  => {perl => '5.010001'},
    resources => {
      homepage   => 'http://www.heise.de',
      bugtracker => 'https://github.com/heiseonline/shariff-backend-perl/issues',
      repository => 'https://github.com/heiseonline/shariff-backend-perl.git'
    },
    no_index => {directory => ['t']}
  },
  PREREQ_PM => {
    'Mojolicious' => '5.0'
  },
  EXE_FILES => ['script/shariff'],
  test => {TESTS => 't/*.t'}
);
