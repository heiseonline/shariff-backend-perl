use 5.010001;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Heise-Shariff',
  VERSION_FROM => 'lib/Heise/Shariff.pm',
  ABSTRACT     => 'Backend for privacy aware share buttons',
  AUTHOR       => 'Philipp Busse <pmb@heise.de>',
  META_MERGE   => {
    requires  => {perl => '5.010001'},
    resources => {
      homepage   => 'http://www.heise.de',
      bugtracker => 'https://github.com/heiseonline/shariff-backend-perl/issues',
      repository => {
        type => 'git',
        url  => 'https://github.com/heiseonline/shariff-backend-perl.git',
        web  => 'https://github.com/heiseonline/shariff-backend-perl',
      },
    },
    no_index => {directory => ['t']}
  },
  PREREQ_PM => {
    'Mojolicious' => '6.0'
  },
  EXE_FILES => ['script/shariff'],
  test => {TESTS => 't/*.t'}
);
