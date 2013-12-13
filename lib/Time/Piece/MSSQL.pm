use strict;
use warnings;
package Time::Piece::MSSQL;
use Time::Piece;
# ABSTRACT: MSSQL-specific methods for Time::Piece

# stolen from timepiece-mysql 
sub import {
  splice @_, 0, 1, 'Time::Piece';
  goto &Time::Piece::import
}

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

=method mssql_datetime

=method mssql_smalldatetime

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

=method from_mssql_datetime

  my $time = Time::Piece->from_mssql_datetime($timestring);

=method from_mssql_smalldatetime

  my $time = Time::Piece->from_mssql_smalldatetime($timestring);

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

BEGIN {
  for (qw(
    mssql_datetime mssql_smalldatetime
    from_mssql_datetime from_mssql_smalldatetime
  )) {
    no strict 'refs'; ## no critic ProhibitNoStrict
    *{"Time::Piece::$_"} = __PACKAGE__->can($_);
  }
}

=head1 FINAL THOUGHTS

This module saves less time than L<Time::Piece::MySQL>, because there are fewer
strange quirks to account for, but it becomes useful when tied to autoinflation
of datatypes in Class::DBI::MSSQL.

=cut

1;
