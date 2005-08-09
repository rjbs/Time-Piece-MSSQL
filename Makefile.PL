use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Time::Piece::MSSQL',
    AUTHOR              => 'Ricardo Signes <rjbs@cpan.org>',
    VERSION_FROM        => 'lib/Time/Piece/MSSQL.pm',
    ABSTRACT_FROM       => 'lib/Time/Piece/MSSQL.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Time::Piece' => 0,
        'Test::More'  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Time-Piece-MSSQL-* cover_db' },
);
