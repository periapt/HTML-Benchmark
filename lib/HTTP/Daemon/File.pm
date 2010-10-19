package HTTP::Daemon::File;

use base HTTP::Daemon;
use URI;
use MIME::Types;
use Perl6::Slurp;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.1');

# Module implementation here

my %DocumentRoot;
my %FileNotFound;

sub new {
    my $class = shift;
    my %opts = @_;
    my $self = HTTP::Daemon->new(%opts);
    bless $self, $class;

    if ($opts{DocumentRoot}) {
        $DocumentRoot{$self} = $opts{DocumentRoot};
    }
    if ($opts{FileNotFound}) {
        $FileNotFound{$self} = $opts{FileNotFound};
    }
    my $fnf = $self->document_root."/".$self->file_not_found;
    croak "File not found file not found: $fnf" if not -r $fnf;
    croak "File not found file is not HTML: $fnf"
        if $self->mime_type($fnf) ne 'text/html';
    return $self;
}

sub document_root {
    my $self = shift;
    return $DocumentRoot{$self};
}

sub file_not_found {
    my $self = shift;
    return $FileNotFound{$self};
}

sub build_response {
    my $self = shift;
    my $path = shift || $self->file_not_found;
    my $file = $self->document_root."/$path";
    if (-r $file) {
        my $type = $self->mime_type($file);
        return HTTP::Response->new(
            200,
            'OK',
            ['Content-Type'=>$type],
            slurp $file,
        );
    }
    return HTTP::Response->new(
        404,
        'File not found',
        ['Content-Type'=>'text/html'],
        slurp  $self->document_root."/".$self->file_not_found,
    );
}

sub run {
    my $self = shift;
    while(my $conn = $self->accept) {
        while(my $request = $conn->get_request) {
            my $uri = URI->new($request->uri);
            $conn->send_response($self->build_response($uri->path));
        }
        $conn->close;
    }
    return;
}

sub mime_type {
    my $self = shift;
    my $file = shift;
    my $types = MIME::Types->new;
    return $types->mimeTypeOf($file);
}

1; # Magic true value required at end of module
__END__

=head1 NAME

HTTP::Daemon::File - Small HTTP server good for test scripts

=head1 VERSION

This document describes HTTP::Daemon::File version 0.0.1

=head1 SYNOPSIS

    use HTTP::Daemon::File
    my $ua = HTTP::Daemon::File->new(
        LocalPort=>8080,
        DocumentRoot=>'t/htdocs',
        FileNotFound=>'file-not-found',
    );
  
=head1 DESCRIPTION

This module provides a small webserver, based upon L<HTTP::Daemon>,
that just knows about a document root and files not found errors.
It is just intended to be embeddable in test scripts using L<Test::TCP>.

=head1 INTERFACE 

=head2 C<new>

This constructor accepts all the arguments that L<HTTP::Daemon> does 
plus the following:

=over 

=item I<DocumentRoot>

The directory where the HTML and other content files are stored.

=item I<FileNotfound>

The file containing HTML content for a 404 response.

=back

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
