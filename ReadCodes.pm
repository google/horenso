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
our @EXPORT = qw(keyboard_layout
                 lang
                 load_priorities
                 process_lines
                 shift_last_char
                 sorted_variants);

my $keyboard_layout = $ENV{HORENSO_KB_LAYOUT} // 'jpn';
my %supported_layouts = (jpn => 1, enu => 1);

if (!defined($supported_layouts{$keyboard_layout})) {
    my $supported_list = join(", ", keys(%supported_layouts));
    print {*STDERR} <<"LAYOUT_ERR";
キーボード配列（\$HORENSO_KB_LAYOUT）“$keyboard_layout”はサポートされていません。
使える配列：$supported_list
LAYOUT_ERR
    exit 1;
}

sub keyboard_layout {
    my ($query_layout) = @_;
    if (defined($query_layout)) {
        return $query_layout eq $keyboard_layout;
    } else {
        return $keyboard_layout;
    }
}

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
            $key =~ s{'}{:}g if keyboard_layout('jpn');

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

sub load_priorities {
    my ($kanji_to_priority) = @_;
    open(my $priority, '<', "$FindBin::Bin/priority/" . lang());
    binmode $priority, ':utf8';
    my $priority_level = 5;
    while (my $line = <$priority>) {
        next if $line =~ m/^#/;
        chomp $line;
        for my $kanji (split q{}, $line) {
            if (defined $kanji_to_priority->{$kanji}) {
                die "優先度データで字が重複している：$kanji";
            }
            $kanji_to_priority->{$kanji} = $priority_level;
        }
        $priority_level--;
    }
}

my %shift_map = (',' => '<',
                 '.' => '>',
                 '/' => '?',
                 ';' => (keyboard_layout('jpn') ? '+' : ':'));
{
    for my $letter ('a'..'z') {
        $shift_map{$letter} = chr(ord($letter) & ~0x20);
    }
    my $numbers_shift = keyboard_layout('jpn') ? q{~!"#$%&'()}
                                               : q{)!@#$%^&*(};
    for my $number (0..9) {
        $shift_map{$number} = substr($numbers_shift, $number, 1);
    }
    %shift_map = (%shift_map, reverse(%shift_map));
}

sub shift_last_char {
    my ($full_key) = @_;
    my @key = split q{}, $full_key;
    $key[-1] = $shift_map{$key[-1]} // $key[-1];
    return join q{}, @key;
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
