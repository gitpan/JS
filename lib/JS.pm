package JS;
use strict;
use warnings;
use File::Find;
use 5.008;

our $VERSION = '0.17';

sub new {
    my $class = shift;
    return bless {@_}, $class;
}

sub run {
    my $self = shift;
    my @args = @_;

    if (! @args) {
        return $self->list_all();
    }
    for my $js_module (@args) {
        $js_module =~ s/\.js$//;
        my @path = $self->find_js_path($js_module)
          or warn("*** Can't find $js_module\n"), next;
        print join "\n", sort(@path), "";
    }
}

sub list_all {
    my $found = {};
    find {
        wanted => sub {
            return unless -f $_;
            return if /\.(?:pm|pod|packlist)$/;
            return if /^\./;
            my $dir = $File::Find::dir;
            $dir =~ s{.*/JS\b(/|$)(.*)}{$2} or return;
            my $module = $dir ? "$dir/$_" : $_;
            if ($module =~ s/\.js$//) {
                $module =~ s/[\/\\]+/./g;
            }
            return if $found->{$module}++;
            print $module, "\n";
        },
    }, grep {-d $_ and $_ ne '.'} @INC;
}

sub find_js_path {
    my $self = shift;
    my $module = shift;
    unless ($module =~ /\//) {
        $module =~ s/(?:\.)/\//g;
    }
    $module =~ s/(?:::)/\//g;
    $module =~ s/\*$/.*/;

    my $found = {};
    my @module_path;
    find {
        wanted => sub {
            my $path = $File::Find::name;
            while (1) {
                return if -d $_;
                return if $path =~ /[\\\/]$module\.pm$/i;
                return if $path =~ /[\\\/]$module\.pod$/i;
                last if $path =~ /[\\\/]$module$/i;
                last if $path =~ /[\\\/]$module\.js(?:\.gz)?$/i;
                return;
            }
            return if $found->{$path}++;
            push @module_path, $path;
        },
    }, grep {-d $_ and $_ ne '.'} @INC;
    return @module_path;
}

1;

=head1 NAME

JS - JavaScript Modules on CPAN

=head1 SYSNOPSIS

    > # Typical unix command line stuff:
    > sudo cpan JS::jQuery
    ... cpan installs JS-jQuery ...
    > js-cpan
    jquery-1.2.3
    jquery-1.2.3.min
    jquery-1.2.3.pack
    jQuery
    > js-cpan jQuery*
    /Library/Perl/5.8.8/JS/jQuery.js
    /Library/Perl/5.8.8/JS/jquery-1.2.3.js
    /Library/Perl/5.8.8/JS/jquery-1.2.3.min.js
    /Library/Perl/5.8.8/JS/jquery-1.2.3.min.js.gz
    /Library/Perl/5.8.8/JS/jquery-1.2.3.pack.js
    > js-cpan jQuery.js
    /Library/Perl/5.8.8/JS/jQuery.js
    > cd my/webapp/that/requires/jquery/javascript/
    > ln -s `js-cpan jQuery.js` jQuery.js

=head1 DESCRIPTION

Some JavaScript modules can be installed from CPAN. This module comes
with a utility called C<js-cpan> that helps you find JavaScript modules
that have been installed on your system so that you can use them in
various projects.

=head1 EXPLANATION

The JSAN project (L<http://openjsan.org>) has successfully provided much
of the groundwork to make JavaScript module distributions look and act
like Perl module distributions.

For example, the basic file layout is similar, the Test::Harness and
Test::Simple framework has been ported to JSAN, and most modules use
Makefiles to set things up.

The Open JSAN project offers the tip off the iceberg in terms of
being a CPAN for JavaScript. However it has a long way to go and not
a lot of community to get it there. CPAN is a good place to put
JavaScript modules.

Many projects require JavaScript components these days, and it would be
nice to simply list them in the META.yml of your Perl project
distributions.

There is a dead simple way to package non-Perl components into Perl/CPAN
distributions. The components get installed in your Perl system but do
not affect Perl in any other way.

JS.pm is a module to explain and help maintain the JavaScript modules
installed from CPAN.

Some module distributions will have both Perl and JavaScript components.
Others will have only JavaScript components. All JavaScript modules and
JavaScript-only distributions should have a top-level-namespace of 'JS'.

=head1 JS MODULE AUTHOR HOWTO

It turns out that Perl's ExtUtils::MakeMaker will install *any*
files that you put in the C<lib/> directory, into your C<perl>'s
C<sitelib>. So setting up a JavaScript distribution is very similar to
setting on a Perl one.

Say you have a JavaScript module called C<Foo.Bar>. First create a
distribution directory called: C<JS-Foo-Bar>. Put your JavaScript code
in C<lib/JS/Foo/Bar.js>. Put your documentation in
C<lib/JS/Foo/Bar.pod>. Create a bare bones C<lib/JS/Foo/Bar.pm> Perl module so
that CPAN related tools can find your stuff.

Your Makefile.PL should look something like this:

    use inc::Module::Install;
    name     'JS-Foo-Bar';
    abstract 'Sample JavaScript Module Distribution';
    version  '0.01';
    license  'lgpl';
    all_from 'lib/JS/Foo/Bar.pod';
    WriteAll;

Create a C<Changes> and C<README> file and dummy C<test.t>. CPAN module
distributions should have these files.

Put your JavaScript tests in a directory called C<tests>. I'll write up
more explicit instructions in a future release, but for now look at
C<JS-YAML> on CPAN or any openjsan.org module as an example.

Now just run these commands:

    perl Makefile.PL
    make
    make manifest
    make dist
    cpan-upload -user foo -passwd bar -mailto foo@bar.com JS-Foo-Bar-0.01.tar.gz

That's it. You've joined the revolution. :)

NOTE: There is a working example JavaScript module shipped with C<JS.pm>
      in the C<examples/JS-Foo-Bar> directory.

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2008. Ingy döt Net.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut