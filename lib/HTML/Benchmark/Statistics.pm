package HTML::Benchmark::Statistics;

use warnings;
use strict;
use Carp;

use Params::Validate;
use Statistics::Descriptive;

use version; our $VERSION = qv('0.0.1');

# Module implementation here

sub new {
    my $class = shift;
    my $self = {
        raw => [],
        combined => {},
    };
    bless $self, $class;
    return $self;
}

sub add_data {
    my $self = shift;
    my %args = validate(@_, {
        website => 1,
        path => 1,
        item => 1,
        type => 1,
        status => 1,
        succeeded => 1,
        size => 1,
        download_time => 1,
        run_uuid => 1,
        label => 1,
        date => {mandatory => 1, isa=>'DateTime'},
    });       
    push @{$self->{raw}}, \%args;

    return unless $args{succeeded};

    my $combined_key = _compile_key(\%args, ['website','path','run_uuid']);
    if (not exists $self->{combined}->{$combined_key}) {
        $self->{combined}->{$combined_key} = {
            website => $args{website},
            path => $args{path},
            run_uuid => $args{run_uuid},
            size=> $args{size},
            download_time => $args{download_time},
            label => $args{label},
            min_date => $args{date},
            max_date => $args{date},
        };
    }
    else {
        $self->{combined}->{$combined_key}->{size}
            += $args{size};
        $self->{combined}->{$combined_key}->{download_time}
            += $args{download_time};
        $self->{combined}->{$combined_key}->{min_date}
            = _min_date(
                $args{date},
                $self->{combined}->{$combined_key}->{min_date}
            );
        $self->{combined}->{$combined_key}->{max_date}
            = _max_date(
                $args{date},
                $self->{combined}->{$combined_key}->{max_date}
            );
    }

    return;
}

sub get_raw_data {
    my $self = shift;
    return @{$self->{raw}};
}

sub get_combined_data {
    my $self = shift;
    return _sort_by_dates('min_date', values %{$self->{combined}});
}

sub get_statistics {
    my $self = shift;

    my %statistics = ();
    foreach my $k (keys %{$self->{combined}}) {
        my %args = %{$self->{combined}->{$k}};
        my $statistics_key = _compile_key(\%args, ['website','path']);
        if (not exists $statistics{$statistics_key}) {
            my $size_stats = Statistics::Descriptive::Sparse->new;
            $size_stats->add_data($args{size});
            my $download_stats = Statistics::Descriptive::Sparse->new;
            $download_stats->add_data($args{download_time});
            $statistics{$statistics_key} = {
                website => $args{website},
                path => $args{path},
                size=> $size_stats,
                download_time => $download_stats,
                label => $args{label},
                min_date => $args{min_date},
                max_date => $args{max_date},
            };
        }
        else {
            $statistics{$statistics_key}->{size}
                ->add_data($args{size});
            $statistics{$statistics_key}->{download_time}
                ->add_data($args{download_time});
            $statistics{$statistics_key}->{min_date}
                = _min_date(
                    $args{min_date},
                    $statistics{$statistics_key}->{min_date}
                );
            $statistics{$statistics_key}->{max_date}
                = _max_date(
                    $args{max_date},
                    $statistics{$statistics_key}->{max_date}
                );
        }
    }

    if ($self->{benchmark}) {
        foreach my $k (keys %statistics) {
            warn "$k exceeded benchmark of $self->{benchmark}"
                if $statistics{$k}->{download_time}->mean > $self->{benchmark};
        }
    }

    return _sort_by_dates('min_date', values %statistics);
}

sub set_benchmark {
    my $self = shift;
    my $benchmark = shift;
    $self->{benchmark} = $benchmark;
}

sub _compile_key {
    my $args = shift;
    my $fields = shift;
    my $key = "";
    foreach my $field (@$fields) {
        $key .= $args->{$field};
        $key .= "|";
    }
    return $key;
}

sub _min_date {
    my $a_date = shift;
    my $b_date = shift;
    return $a_date->subtract_datetime($b_date)->is_negative ? $a_date : $b_date;
}

sub _max_date {
    my $a_date = shift;
    my $b_date = shift;
    return $a_date->subtract_datetime($b_date)->is_positive ? $a_date : $b_date;
}

sub _cmp {
    my $field = shift;
    my $a = shift;
    my $b = shift;
    my $c = $b->{$field}->subtract_datetime($a->{$field});
    return 1 if $c->is_negative;
    return -1 if $c->is_positive;
    return 0;
}

sub _sort_by_dates {
    my $field = shift;
    my @dates = @_;
    return sort {_cmp($field, $a, $b) } @dates;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

HTML::Benchmark::Statistics - Performance analysis of web pages and sites

=head1 VERSION

This document describes HTML::Benchmark::Statistics version 0.0.1

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
