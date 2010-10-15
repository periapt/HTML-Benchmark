package HTML::Benchmark;

use LWP::UserAgent;
use Format::Human::Bytes;
use DateTime;
use URI;

# Used by get_and_time
use Time::HiRes qw(time tv_interval);

# Used by generate_uuid
use UUID qw(generate);
use MIME::Base64;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.1');

use Class::XSAccessor
    replace => 1,
    accessors => [
        'useragent',
        'label',
    ];

# Module implementation here

sub new {
    my $class = shift;
    my $self = { @_ };
    bless $self, $class;

    $self->useragent(LWP::UserAgent->new) if not $self->useragent;
    return $self;
}

sub benchmark {
    my $self = shift;
    my $url = shift;
    my $uri = URI->new($url);
    my $website = ($uri->scheme).'://'.($uri->host);
    my $path = $uri->path;
    my $item = $path;
    print "Website: $website\n";
    print "Path: $path\n";
    print "Item: $item\n";
    print "Class: 0\n";
    my ($response, $interval) = $self->get_and_time($url);
    print "Interval: $interval\n";
    my $status = $response->code;
    print "Status: $status\n";
    my $type = $response->header('Content-Type');
    if ($type =~ m{
                    \A
                    ([\w\/\-]+)
                    ;
                    \s+
                    charset=
                }xms
    ) {
        $type = $1;
    }
    print "Type: $type\n";
    my $length = 'n/a';
    if ($response->is_success) {
        $length
            = Format::Human::Bytes::base2(length $response->decoded_content);
    }
    print "Size: $length\n";
    if ($self->label) {
        my $label = $self->label;
        print "Label: $label\n";
    }
    my $date = DateTime->now()->strftime('%c');
    print "Date: $date\n";
    my $uuid = $self->generate_uuid;
    print "UUID: $uuid\n";
    return;
}

sub get_and_time {
    my $self = shift;
    my $url = shift;
    my $pretime = time;
    my $response = $self->useragent->get($url);
    my $interval = time - $pretime;
    return ($response, $interval);
}

sub generate_uuid {
    my $self = shift;
    my $uuid = "";
    generate($uuid);
    $uuid = encode_base64($uuid);
    return $uuid;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

HTML::Benchmark - Performance analysis of web pages and sites

=head1 VERSION

This document describes HTML::Benchmark version 0.0.1

=head1 SYNOPSIS

    use HTML::Benchmark;
    my $ua = HTML::Benchmark->new;
    $ua->benchmark('http://www.periapt.co.uk');
  
=head1 DESCRIPTION

This module provides a back-end to the website performance analysis tool
L<html_benchmark>. Most of the methods are for configuration purposes.
The signature method C<benchmark> takes a single page and gets a realistic
and detailed analysis of the performance of that web-page and handles 
those results as directed. Typically the action is either to write the results
to a database for further analysis or to display them.

=head1 INTERFACE 

=head2 C<new>

This constructor can initialize the various fields described below.

=head2 C<benchmark>

This is the key method. It runs the experiments and either displays the
results or writes them to the database.

=head2 C<get_and_time>

This is a wrapper around L<LWP::UserAgent>'s get method. It returns a
L<HTTP::Response> object and the time taken to obtain the response.

=head2 C<generate_uuid>

This generates a base64 encoded unique identifier.

=head2 C<useragent>

This returns or sets the user agent. By default it will be a L<LWP::UserAgent>
object.

=head2 C<label>

This is a bit of free text that is passed straight through. It can 
be used to group related test results.

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
HTML::Benchmark requires no configuration files or environment variables.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-html-benchmark@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Nicholas Bamber  C<< <nicholas@periapt.co.uk> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Nicholas Bamber C<< <nicholas@periapt.co.uk> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
