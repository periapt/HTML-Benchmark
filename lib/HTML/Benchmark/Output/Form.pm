package HTML::Benchmark::Output::Form;

use warnings;
use strict;
use Carp;

use Params::Validate;
use Perl6::Form;

use version; our $VERSION = qv('0.0.1');

# Module implementation here

sub new {
    my $class = shift;
    my $benchmark = shift;
    my %args = @_;
    my $self = {
        benchmark => $benchmark,
        args => \%args,
    };
    bless $self, $class;
    return $self;
}

sub output {
    my $self = shift;
    my $statistics = $self->{benchmark}->statistics;
    return form "==============================";
}

1; # Magic true value required at end of module
__END__

=head1 NAME

HTML::Benchmark::Output::Form - display basic statistics

=head1 VERSION

This document describes HTML::Benchmark::Output::Form version 0.0.1

=head1 SYNOPSIS

    use HTML::Benchmark:Statistics;
    my $stats = HTML::Benchmark::Statistics->new;
    $stats->add_data(.........);
    return $stats->get_statistics->{download_time}->mean;
  
=head1 DESCRIPTION

This module provides a base class for handling the raw data, for
compiling the combined and averaged data.

=head1 INTERFACE 

=head2 C<new>

This constructor requires no arguments.

=head2 C<add_data>

This method takes some raw data updates the higher level data.
The fields expected are as follows:

=over

=item I<website>

=item I<path>

=item I<item>

=item I<type>

=item I<status>

=item I<succeeded>

=item I<size>

=item I<download_time>

=item I<run_uuid>

=item I<label>

=item I<date>

=back

=head2 C<get_raw_data>

This returns an array of all the raw data.

=head2 C<get_combined_data>

This compiles the data at a page level. So the download_time
is the sum of the download time for the HTML, images, CSS and javascript.
Similarly for size. The fields included are I<website>, I<path>, I<run_uuid>,
I<download_time>, I<size>, I<label>, I<min_date>, I<max_date>.
Combined data does not include failed runs.

=head2 C<get_statistics>

This compiles the data into a L<Statistics::Descriptive> object
at a page level across the various runs.
So the download_time
is a L<statistics::Descriptive::Sparse> of the download times for the
combined download times across the various runs.
Similarly for size. The fields included are I<website>, I<path>,
I<download_time>, I<size>, I<runs>, I<label>, I<min_date>, I<max_date>.

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
