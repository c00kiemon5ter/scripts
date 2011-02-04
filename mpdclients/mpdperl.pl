#!/usr/bin/perl
# vim: ts=4 sw=4

use strict;
use warnings;
use IO::Socket;
use List::Util;

# a somewhat idiosyncratic script for interacting with a MPD server at the
# protocol level.
# The commandline works like a stack of commands that are executed in
# order which manipulates a datastack that can be easily send back and forth.
#
# Example: To get the current playing songtitle
# wut hd currentsong -- get title

# Example: To clear the playlist, add 5 random albums and begin playing
# wut ls album shuffle first 5 -files add newlist --

my %mpd_config = (
    PeerAddr    => "localhost",
    PeerPort    => 6600,
);

my $tmp;
my $quiet;
my @ds = ();        # data stack
my @is = @ARGV;     # instruction stack
my %commands=();

sub grab { shift @is } ;
sub stash { @is=(@_,@is) } ;
sub call {
    my ($cmd,@args) = @_;
    stash(@args);
    $commands{$cmd}->();
};
sub communicate {
    my $socket = IO::Socket::INET->new(%mpd_config) || die "could not create socket: $!\n";
    my $l = $socket->getline;
    chomp $l;
    die "not a mpd server" if $l !~ /^OK MPD (.+)$/;
    map { $socket->print($_ . "\n") } @ds;
    my @recv = ();
    while(defined(my $line = $socket->getline)){
        chomp $line;
        die $line if $line =~ s/^ACK //;
        push @recv,$line;
        last if $line =~ /^OK/;
    }
    $socket->close;
    @ds = ($l,@recv);
};

%commands = (
    "--"            => sub { call("cmdlist"); communicate },
    "-"             => sub { @ds = map { chomp;$_ } <STDIN> },
    "hd"            => sub { @ds = ( grab, @ds ) },
    "tl"            => sub { @ds = ( @ds, grab ) },
    "shuffle"       => sub { @ds = List::Util::shuffle(@ds); } ,
    "quote"         => sub { @ds = map { '"' . $_ . '"' } @ds },
    "reverse"       => sub { @ds = reverse @ds },
    "first"         => sub { my $n = grab; @ds = @ds[0..($n-1)] },
    "last"          => sub { my $n = grab; @ds = @ds[$#ds-$n+1 .. $#ds] },
    "prepend"       => sub { my $n = grab; @ds = map { $n . $_ } @ds; },
    "append"        => sub { my $n = grab; @ds = map { $_ . $n } @ds; },
    "grep"          => sub { my $n = grab; @ds = grep( /$n/i,@ds) },
    "filter"        => sub { my $n = grab; @ds = grep(!/$n/i,@ds) },
    "get"           => sub { my $n = grab; @ds = map {s/^$n: //i;$_} grep /^$n:/i,@ds; },
    "num"           => sub { @ds = map { /^(\d+):/;$1 } grep { /^\d+:/ } @ds },
    "uniq"          => sub { my %seen =(); @ds = grep { ! $seen{$_} ++ } @ds },
    "ls"            => sub { $tmp = grab;stash ("hd",$tmp,"prepend", "list ","--", "get",$tmp) },
    "add"           => sub { stash ("quote","prepend", "add ") },
    "newlist"       => sub { stash ("hd","clear","tl","play") },
    "albums"        => sub { stash ("get","directory","quote","prepend", "lsinfo ", "--", "get", "directory") },
    "cmdlist"       => sub { call("hd","command_list_begin"); call("tl","command_list_end"); },
    "play"          => sub { stash ("hd",grab,"prepend","play ","--") },
    "q"             => sub { $quiet = 1 },
    "toggle"        => sub { stash ("hd","pause","--") },
    "cs"            => sub { stash ("hd","currentsong","--")},
    "volume"        => sub { stash ("hd",grab,"prepend","setvol ","--")},
    "id"            => sub { stash ("num","prepend","playlistinfo ", "--", "get", "Id") },
    "-files"        => sub { stash( "quote","prepend"," $tmp ","prepend","list file", "--","get","file") },
    "playlist"      => sub { stash( "hd","playlist","--") },
    "randalbums"    => sub { stash( "ls","album","shuffle","first",grab,"-files","add","newlist","--") },
);

sub process {
    if(@is > 0) {
        my $word = grab;
        die "unknown word: $word" if not(exists($commands{$word}));
        $commands{$word}->();
        process() ;
    }
}
process;
map { print $_,"\n" } @ds unless $quiet;

