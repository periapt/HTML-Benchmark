package HTML::Benchmark::Parser;
use base HTML::Parser;

use warnings;
use strict;
use Carp;


use version; our $VERSION = qv('0.0.1');

# Module implementation here

sub new {
    my $class = shift;
    my $self = HTML::Parser->new(
        api_version => 3,
        start_h  => [&_start, 'self,tagname,attr'],
        report_tags => ['link','script','img'],
    );
    $self->{b_link} = [];
    $self->{b_script} = [];
    $self->{b_img} = [];
    bless $self, $class;
    return $self;
}

sub extract_data {
    my $self = shift;
    my $content = shift;
    $self->parse($content);
    $self->eof;
    return $self->{b_link}, $self->{b_script}, $self->{b_img};
}

sub _start {
}

1; # Magic true value required at end of module
__END__

=head1 NAME

HTML::Benchmark::Parser - extract CSS, Javascript and image data

=head1 VERSION

This document describes HTML::Benchmark::Parser version 0.0.1

=head1 SYNOPSIS

    use HTML::Benchmark::Parser;
    my $parser = HTML::Benchmark::Parser->new;
    my ($links, $scripts, $img) = $parser->extract_data($html);
  
=head1 DESCRIPTION

This module extracts URLs for CSS, javascript and images.

=head2 C<new>

This constructor requires no arguments.

=head2 C<extract_data>

This method takes HTML as an argument and returns three array references, 
each containing URLs extracted from the HTML. These represent respectively
the CSS, javascript and images.

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
