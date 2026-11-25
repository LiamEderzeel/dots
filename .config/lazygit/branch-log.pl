#!/usr/bin/perl
# Post-process `git log --graph` output:
#  - replace the commit `*` with a circle colored like its branch lane
#  - reduce author names (wrapped in @@...@@) to initials
use strict; use warnings; use utf8;
binmode STDIN,  ':utf8';
binmode STDOUT, ':utf8';

my @lines = <STDIN>;

sub cells {
    my ($l) = @_;
    my (@c, $cur);
    $cur = '';
    while ($l =~ /\G(\e\[[0-9;]*m|.)/gcs) {
        my $t = $1;
        if ($t =~ /^\e/) { $cur = ($t eq "\e[m") ? '' : $t; next }
        push @c, [$cur, $t];
    }
    return \@c;
}
my @cells = map { cells($_) } @lines;

for my $i (0 .. $#lines) {
    my $l = $lines[$i];

    if ($l =~ /^((?:\e\[[0-9;]*m|[^*\e])*)\*/) {
        my $pre = $1;
        (my $vis = $pre) =~ s/\e\[[0-9;]*m//g;
        my $p = length $vis;

        my $color = '';
        for my $dir (-1, 1) {
            my $j = $i + $dir;
            while ($j >= 0 && $j <= $#lines) {
                my $c = $cells[$j][$p];
                last unless $c && $c->[1] =~ /^[|*]$/;
                if ($c->[1] eq '|' && $c->[0] ne '') { $color = $c->[0]; last }
                $j += $dir;
            }
            last if $color;
        }
        substr($l, length($pre), 1) = $color . "\x{25CF}" . "\e[m";
    }

    $l =~ s/@@(.*?)@@/join "", map { uc substr($_,0,1) } split " ", $1/ge;
    print $l;
}
