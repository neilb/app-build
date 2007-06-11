#!/usr/bin/perl -w

use strict;
use lib qw(t/lib);
use Test::More tests => 6;
use TestAppBuild;
use App::Build;
use ExtUtils::Command qw();

clean_install();

eval { require Archive::Extract };
SKIP: {
    skip 'No Archive::Extract, skipping unpack() tests', 2 if $@;

    my $build1 = App::Build->new
      ( module_name  => 'Foo::Boo',
        dist_version => '0.01',
        quiet        => 1,
        );
    $build1->unpack( 't/data/Foo.tar.gz', 't/test_install/mumbo', 'Foo' );

    is( -s 't/test_install/mumbo/Foo/Build.PL', 551 );
    is( -s 't/test_install/mumbo/Foo/cgi-bin/foo/foo.conf', 20 );
    ok( !-e 't/test_install/mumbo/Foo/dummy' );

    {
        local @ARGV = 't/test_install/mumbo/Foo/dummy';
        ExtUtils::Command::touch();
    }

    $build1->unpack( 't/data/Foo.tar.gz', 't/test_install/mumbo', 'Foo' );

    is( -s 't/test_install/mumbo/Foo/Build.PL', 551 );
    is( -s 't/test_install/mumbo/Foo/cgi-bin/foo/foo.conf', 20 );
    ok( !-e 't/test_install/mumbo/Foo/dummy' );
}
