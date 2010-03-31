use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'JS::JS',
    AUTHOR              => q{Juan Manuel Torres <juan-manuel.torres@univ-avignon.fr>},
    VERSION_FROM        => 'lib/JS/JS.pm',
    ABSTRACT_FROM       => 'lib/JS/JS.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'JS-JS-*' },
);
