package Time::Piece::MSSQL;

use Time::Piece;
use warnings;
use strict;

# stolen from timepiece-mysql 
sub import { shift; unshift @_, 'Time::Piece'; goto &Time::Piece::import }

=head1 NAME

Time::Piece::MSSQL - MSSQL-specific methods for Time::Piece

=head1 VERSION

version 0.01

 $Id: MSSQL.pm,v 1.2 2004/10/26 16:55:53 rjbs Exp $

=cut

$Time::Piece::MSSQL::VERSION = '0.01';

=head1 SYNOPSIS

 use Time::Piece::MSSQL;

 my $time = localtime;

 print $time->mssql_datetime;
 print $time->mssql_smalldatetime;

 my $time = Time::Piece->from_mssql_datetime( $mssql_datetime );
 my $time = Time::Piece->from_mssql_smalldatetime( $mssql_smalldatetime );

=head1 DESCRIPTION

This module adds functionality to L<Time::Piece>, providing methods useful for
using the object in conjunction with a Microsoft SQL database connection.  It
will produce and parse MSSQL's default-format datetime values.

=head1 METHODS

=cut

package Time::Piece;

=head2 C<< Time::Piece->mssql_datetime >>

=head2 C<< Time::Piece->mssql_smalldatetime >>

These methods return the Time::Piece object, formatted in the default notation
for the correct MSSQL datatype.

=cut

sub mssql_datetime {
	my $self = shift;
	$self->strftime('%Y-%m-%d %H:%M:%S.000');
}

sub mssql_smalldatetime {
	my $self = shift;
	$self->strftime('%Y-%m-%d %H:%M:%S');
}

=head2 C<< Time::Piece->from_mssql_datetime($timestring) >>

=head2 C<< Time::Piece->from_mssql_smalldatetime($timestring) >>

These methods construct new Time::Piece objects from the given strings, which
must be in the default MSSQL format for the correct datatype.  If the string is
empty, undefined, or unparseable, C<undef> is returned.

=cut

sub from_mssql_datetime {
	my ($class, $timestring) = @_;
	return unless $timestring and ($timestring =~ s/\.\d{3}$//);
	my $time = eval { $class->strptime($timestring, '%Y-%m-%d %H:%M:%S') };
}

sub from_mssql_smalldatetime {
	my ($class, $timestring) = @_;
	return unless $timestring;
	my $time = eval { $class->strptime($timestring, '%Y-%m-%d %H:%M:%S') };
}

=head1 FINAL THOUGHTS

This module saves less time than L<Time::Piece::MySQL>, because there are fewer
strange quirks to account for, but it becomes useful when tied to autoinflation
of datatypes in Class::DBI::MSSQL.

=head1 AUTHOR

Ricardo Signes, C<< <rjbs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-time-piece-mssql@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT

Copyright 2004 Ricardo Signes, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
