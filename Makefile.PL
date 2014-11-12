use 5.010001;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Heise-Shariff',
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
