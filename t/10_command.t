#!perl

use strict;
use warnings;

use Test::Fatal;
use Test::More tests => 13;
use FindBin qw($Bin);

use AtomicParsley::Command::Tags;

BEGIN { use_ok('AtomicParsley::Command'); }
require_ok('AtomicParsley::Command');

my $ap;
my $tags;
my $testfile = "$Bin/resources/Family.mp4";

$ap = new_ok('AtomicParsley::Command');
like( $ap->{ap}, qr/AtomicParsley$/ );
is( $ap->{verbose}, 0 );

# _parse_tags
my $output = 'Atom "�nam" contains: Family (Mock the Week)
Atom "�ART" contains: Milton Jones
Atom "aART" contains: Milton Jones
Atom "gnre" contains: Comedy
Atom "tvsh" contains: Milton Jones
';
$tags = $ap->_parse_tags($output);
is( $tags->{title}, 'Family (Mock the Week)', 'title' );
is( $tags->{genre}, 'Comedy', 'genre' );

# write_tags
my $write_tags = AtomicParsley::Command::Tags->new(
    artist    => 'test_artist',
    title     => 'test_title',
    album     => 'test_album',
    genre     => 'test_genre',
    tracknum  => '1/10',
    disk      => '1/2',
    comment   => 'test_comment',
    year      => '2011',
    lyrics    => 'test_lytics',
    composer  => 'test_composer',
    copyright => 'test_copyright',
    grouping  => 'test_grouping',

    #artwork => 'test_
    bpm         => '12',
    albumArtist => 'test_albumArtist',

    #compilation => 'true',
    advisory     => 'clean',
    stik         => 'Movie',
    description  => 'test_description',
    TVNetwork    => 'test_TVNetwork',
    TVShowName   => 'test_TVShowName',
    TVEpisode    => 'test_TVEpisode',
    TVSeasonNum  => '1',
    TVEpisodeNum => '2',

    #podcastFlag => 'false',
    category => 'test_category',
    keyword  => 'test_keyword',

    #podcastURL => 'http://andrew-jones.com',
    #podcastGUID
    #purchaseDate
    encodingTool => 'test_encodingTool',

    #gapless => 'true',
);
my $tempfile = $ap->write_tags( $testfile, $write_tags );
ok( -e $tempfile );

# read_tags
my $read_tags = $ap->read_tags($tempfile);
is_deeply( $read_tags, $write_tags, 'read/write tags' );

$ap->read_tags('/does/not/exist');
ok( !$ap->{success} );
like( $ap->{stdout_buf}[0],
    qr/AP error trying to fopen: No such file or directory/ );

isnt(
    exception {
        $ap = AtomicParsley::Command->new( { ap => 'foo', } );
    },
    undef
);

unlink $tempfile;
ok( !-e $tempfile );
