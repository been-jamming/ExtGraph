#!/usr/bin/perl -W
# Some code generated by `find2perl . -iname "*.{c,h}"`
use strict;
use File::Find ();

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

package main;
    my $sourcecode;
    my %funcs;

sub wanted {
    my $line;
    my @lines;
    my ($filename, $funcname);
    my $regex;
    
    if (($name !~ m@/_copie@) && ($name !~ m@Slower@)) { # Skip local backups of files and old routines.
        if ($name =~ m@(\C*?)\.(s|c)$@i) { # Select .s and .c files.

            @lines = split /\//, $1;
            $filename = $lines[$#lines];

            open(INFILE, '+<', $name) or die "Can't open $name: $!";
            read(INFILE, $sourcecode, -s INFILE);
            close INFILE;
            
            if ($name =~ m@\.s$@i) { # .s file
                @lines = split /\n/, $sourcecode;
                if ($lines[$#lines] ne "") {
                    push @lines, "";
                }

                # Does this file contains a mention of its C prototype ?
                if ($lines[0] =~ m@\|\sC\sprototype:\s(\C*?)\s(\S+)\s?\((\C+)$@) {
                    $funcname = $2;
                    if (lc($filename) eq lc($funcname)) {
                        # OK, this file seems to be named after the function it contains.
                        if (!defined($funcs{$funcname})) {
                            warn "File $name has a prototype for $funcname, but that function name was not found in the headers.\n";
                        }
                        else {
                            $lines[0] = "| C prototype: $funcs{$funcname}";

                            # While we're at it, check that this file contains an appropriate .globl
                            # declaration and an appropriate label.
                            # \n\C*?$funcname\:\n
                            
                            $regex = qr@(xdef|\.globl)\ $funcname\C*?$funcname\:@s;
                            if ($sourcecode !~ $regex) {
                                warn "WARNING: file $name doesn't contain a proper declaration of $funcname !\n";
                            }
                            open(OUTFILE, '+>', "$name") or die "Can't open $name: $!";
                            print OUTFILE join ("\n", @lines);
                            close OUTFILE;

                            delete $funcs{$funcname};
                            delete $funcs{lc($funcname)};
                        }
                    }
                    else {
                        warn "Mismatch between file name $name and embedded prototype for $funcname\n";
                    }
                }
                else {
                    if (!defined($funcs{lc($filename)})) {
                        warn "File $name has no prototype for $filename, and that function name was not found in the headers.\n";
                    }
                    delete $funcs{$filename};
                    delete $funcs{lc($filename)};
                }
            }
            else { # C file.
                $regex = qr@$filename@si;
                if ($sourcecode =~ $regex) {
                    if (!defined($funcs{lc($filename)})) {
                        warn "WARNING: file $name contains string $filename, but no corresponding prototype found in the headers.\n";
                    }
                    else {
                        warn "File $name contains string $filename, check the prototype.\n";
                    }
                }
                else {
                    warn "WARNING: file $name doesn't seem to contain symbol $filename !\n";
                }
                delete $funcs{$filename};
                delete $funcs{lc($filename)};
            }
        }
    }

}

sub parse ($) {
    my $filename = shift;
    my $spuriousindex;
    
    open(INFILE, $filename) or die "Can't open $filename: $!";
    read(INFILE, $sourcecode, -s INFILE);
    close INFILE;
    # Select only the function prototypes defined in extgraph.h
    ($sourcecode =~ m@//\-\-BEGIN_FUNCTION_PROTOTYPES\-\-//(\C*?)//\-\-END_FUNCTION_PROTOTYPES\-\-//@gso) or die "Can't find necessary comments in extgraph.h\n";
    $sourcecode = $1;

    my @lines = split /\n/, $sourcecode;
    for my $line (@lines) {
        
        next if (   ($line =~ m@^\s?$@o) # Empty line
                 || ($line =~ m@^\#@o) # Line starting with #
                 || ($line =~ m@^//@o) # Line starting with //
                 || ($line =~ m@^/\*@o) # Line starting with /*
                 || ($line =~ m@^\ \*@o) # Line starting with ' *'
                );
        
        ($line =~ m@^(\C*?)\s(\S+)\s?\((\C+)$@o) or die "Strange line \"$line\"\n";
        # Function $2 has (almost) prototype $line.
        
        # Strip trailing Doxygen comment if any.
        $spuriousindex = index($line, " ///< ");
        if ($spuriousindex != -1) {
            $line = substr ($line, 0, $spuriousindex);
        }
        
        $spuriousindex = index($line, "extern ");
        if ($spuriousindex != -1) {
            $line = substr ($line, length("extern "));
        }
        
        $funcs{$2} = $line;
        $funcs{lc($2)} = $line;
    }
}


    # Read input files.
    parse "../../lib/extgraph.h";
    parse "../../lib/tilemap.h";
    parse "../../lib/preshift.h";
    
    # Traverse desired filesystem
    File::Find::find({wanted => \&wanted, no_chdir => 1}, '.');

    for my $key (sort keys %funcs) {
        print "Found no implementation for function $key\n";
    }

