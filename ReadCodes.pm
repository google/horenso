# Copyright 2016 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use utf8;
use warnings;

use Exporter qw(import);
use FindBin;

package ReadCodes;

our $VERSION = 1.00;
our @EXPORT = qw(lang
                 process_lines
                 read_priorities
                 sorted_variants);

sub lang {
    my ($query_lang) = @_;
    my $lang = $ENV{HORENSO_LANG} // 'jpn';
    if (defined($query_lang)) {
        return $query_lang eq $lang;
    } else {
        return $lang;
    }
}

sub process_lines(&) {
    my ($process_line) = @_;

    my @dirs = ("$FindBin::Bin/code");

    while (@dirs) {
        my $path = pop @dirs;
        next if $path =~ m{/\.+$};
        if (-d $path) {
            opendir my $dir_handle, $path or die "$!";
            push @dirs, map { "$path/$_" } readdir($dir_handle);
            next;
        }

        open(my $codes, '<', $path) or die "Cannot open $path: $!";
        binmode $codes, ':utf8';
        while (my $line = <$codes>) {
            chomp $line;
            my ($key, $value, @notes) = split m{\t}, $line;
            if (!defined($value)) {
                print {*STDERR} "コードファイルの行の処理に失敗した：$line\n";
                die;
            }
            my %notes_by_prefix;
            for my $note (@notes) {
                for my $note_type (qw(b y hb hy itj ktj sjt)) {
                    if ($note =~ m{^\Q$note_type\E(.*)$}) {
                        push @{$notes_by_prefix{$note_type}}, $1;
                    }
                }
            }
            $process_line->($key, $value, %notes_by_prefix);
        }
    }
}

sub read_priorities {
    my ($kanji_to_priority) = @_;
    open(my $priority, '<', "$FindBin::Bin/priority/" . lang());
    binmode $priority, ':utf8';
    my $priority_level = 5;
    while (my $line = <$priority>) {
        next if $line =~ m/^#/;
        chomp $line;
        for my $kanji (split q{}, $line) {
            $kanji_to_priority->{$kanji} //= $priority_level;
        }
        $priority_level--;
    }
}

sub sorted_variants {
    my ($main, %notes_by_prefix) = @_;
    my @all_variants = ($main);
    my $sjt = $notes_by_prefix{sjt} // [];

    my $preferred = (@$sjt && lang('jpn')) ? $sjt->[0] : $main;

    push @all_variants, @$sjt;
    push @all_variants, @{$notes_by_prefix{itj} // []};

    @all_variants = sort(@all_variants);

    for my $i (0..$#all_variants) {
        if ($all_variants[$i] eq $preferred) {
            $all_variants[$i] = $all_variants[0];
            $all_variants[0] = $preferred;
            last;
        }
    }

    return @all_variants;
}

1;
